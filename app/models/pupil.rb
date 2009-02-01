##################################################################################
##                                                                              ##
##                           Copyright (c) Robert Jones 2006                    ##
##                                                                              ##
##  This file is part of FreeMIS.                                               ##
##                                                                              ##
##  FreeMIS is free software; you can redistribute it and/or modify             ##
##  it under the terms of the GNU General Public License as published by        ##
##  the Free Software Foundation; either version 2 of the License, or           ##
##  (at your option) any later version.                                         ##
##                                                                              ##
##  FreeMIS is distributed in the hope that it will be useful,                  ##
##  but WITHOUT ANY WARRANTY; without even the implied warranty of              ##
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               ##
##  GNU General Public License for more details.                                ##
##                                                                              ##
##  You should have received a copy of the GNU General Public License           ##
##  along with FreeMIS; if not, write to the Free Software                      ##
##  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA  ##
##                                                                              ##
##################################################################################
class Pupil < ActiveRecord::Base
  has_and_belongs_to_many :pupil_sets, :join_table => "setlinks", :uniq=>true
  validates_inclusion_of :gender, :in=>%w( m f ), :message=>"gender must be either m or f"
  has_many :setlinks, :conditions=>"setlink_end_date IS NULL"
  has_many :positives, :order=>"updated_at DESC"
  has_many :tracking_element_data
  belongs_to :guidance_group
  belongs_to :academic_year
  has_many :reports, :include=>[:pupil, [:generic_report_element_data=>:generic_report_element],[:assessed_element_data=>:assessed_element], [:setlink=>[:pupil_set=>[:course, :academic_year]]]]
  has_and_belongs_to_many :parental_units, :join_table=>"parent_link"
  has_many :merits
  has_many :guidance_reports, :include=>[:guidance_report_element_data=>:guidance_report_element]
  has_many :generic_report_element_data, :finder_sql=>'SELECT generic_report_element_data.* FROM generic_report_element_data, reports, pupils 
                                                       WHERE pupils.id=#{id}
                                                       AND reports.pupil_id=pupils.id
                                                       AND generic_report_element_data.report_id=reports.id'
  has_many :gradebook_scores, :dependent=> :destroy
  
  # Add a pupil to a set, if they are not already in it.
  #
  # Example:
  #   @pupil_set = @pupil.add_to_set(set_id)
  #
  def add_to_set(set_to_add)
      #set_to_add=PupilSet.find(set_id)
      if @setlink=self.setlinks.find(:first, :conditions=>["pupil_set_id=?",set_to_add.id])
        @setlink.update_attributes({"setlink_end_date"=>nil})
      else
        self.pupil_sets << set_to_add unless self.academic_year_id != set_to_add.academic_year_id
        self.save
        set_to_add
      end
  end

  def current_tracking_element_data
    self.tracking_element_data.find(:all, :conditions=>"school_session_id=#{SchoolSession.current.id}") rescue nil
  end

  def historical_pupil_sets(school_session=SchoolSession.current)
    PupilSet.find_by_sql(["SELECT pupil_sets.* from pupil_sets, setlinks WHERE
                           setlinks.pupil_id=? AND
                           setlinks.pupil_set_id=pupil_sets.id AND
                           pupil_sets.school_session_id=?",id,school_session.id])
  end

  def all_setlinks_this_session(active_session=SchoolSession.current)
    Setlink.find_by_sql(["select setlinks.* from setlinks, pupil_sets where pupil_set_id=pupil_sets.id and pupil_id=? and pupil_sets.school_session_id=? and pupil_sets.course_id<>0",id, active_session.id])
  end

  def all_setlinks
    Setlink.find_by_sql(["select setlinks.* from setlinks where setlinks.pupil_id=?",id])
  end
  
  def primary_residential_parental_unit
    if self.parental_units.length>0
      self.parental_units.first
    else
      ParentalUnit.new({"names"=>" Parent/Guardian"})
    end
  end

  # This method is just a helper to display the current target for a pupil on their interim report
  def interim_target(course_id)
    @target_element=self.academic_year.interim_tracking_element 
    if @target_element 
        this= self.tracking_element_data.find(:first, :conditions=>"course_id=#{course_id} and tracking_element_id=#{@target_element.id} and school_session_id=#{SchoolSession.current.id}")
        this.value if this
    end
  end
  

  def remove_from_set(set)
    setlink=Setlink.find(:first, :conditions=>["pupil_id=? and pupil_set_id=? and setlink_end_date IS NULL",self.id,set.id])
    setlink.update_attributes({"setlink_end_date"=>Time.now}) if setlink
  end

  def self.search(terms)
    find_by_sql(["select t.* from pupils t where #{ (["(lower(t.known_as) like ? or lower(t.surname) like ?)"] * terms.size).join(" and ") }and t.leave_date is NULL order by t.surname asc", *(terms * 2).sort])
  end

  def current_reports(session_id=SchoolSession.current.id)
    self.reports.select{|s| s.school_session_id==session_id}.sort_by { |a| a.setlink.pupil_set.course.course_subject}
  end

  def full_name
    self.known_as.to_s + " " + self.surname.to_s + " " + (self.guidance_group && self.guidance_group.code)
  end

  def name
    self.known_as.to_s + " " + self.surname.to_s
  end

  def pronoun
    (self.gender=="m" || self.gender=="M") ? "he" : "she"
  end

   def objective_pronoun
    (self.gender=="m" || self.gender=="M") ? "him" : "her"
  end
  
  def possessive_pronoun
    (self.gender=="m" || self.gender=="M") ? "his" : "her"
  end

  def setlinks_with_interim_report_data(active_session=SchoolSession.current)
    self.all_setlinks_this_session(active_session).select{|x| x.interim_report_element_data.reject{|x| x.element_value==""}!=[]}
  end

  ##
  # Produces the data for a pupil's interim report in a hash
  #
  def interim_report(school_session=SchoolSession.current)
    @this_academic_year=historical_pupil_sets(school_session).first.academic_year rescue nil
    if @this_academic_year==nil
      return nil
    else
      return_hash=Hash.new
      return_hash["headers"]=@this_academic_year.interim_report_elements rescue nil
      return_hash["tracking_header"]=@this_academic_year.interim_tracking_element.element rescue nil
      body_rows=Array.new
      for setlink in self.setlinks_with_interim_report_data(school_session).sort_by{|x| x.pupil_set.course.course_subject}
        body_row=Hash.new
        body_row["subject"]=setlink.pupil_set.course.course_subject
        body_row["level"]=setlink.pupil_set.course.course_level.code
        body_row["target"]=self.interim_target(setlink.pupil_set.course_id) if return_hash["tracking_header"]
        data=Array.new
        if setlink.interim_report_element_data
          for header in return_hash["headers"]
            data << setlink.interim_report_element_data.detect{|datum| datum.interim_report_element==header}
          end
        end
        body_row["data"]=data
        body_rows << body_row if body_row["data"].reject{|d| !d }!=[]
      end
      return_hash["body_rows"]=body_rows
      return_hash
    end
  end

  def faculty_reports(faculty)
#    reports.select{|r| r.course.faculty==faculty}
    Report.find_by_sql(["select reports.* from reports, setlinks, pupil_sets, courses 
                         where reports.setlink_id=setlinks.link_id and setlinks.pupil_set_id= pupil_sets.id
                         and setlinks.pupil_id=?
                         and pupil_sets.course_id=courses.id and courses.faculty_id=?",id,faculty.id])
  end

  def current_guidance_report(session=SchoolSession.current)
    self.guidance_reports.find(:first, :conditions=>["school_session_id=?",session.id])
  end

## merit award method - probably won't be used by most schools!
  def merit_award
    if merits.count>=academic_year.merit_cutoffs.find(:first, :conditions=>"level='gold'").cutoff then
      level="gold"
    elsif merits.count>=academic_year.merit_cutoffs.find(:first, :conditions=>"level='silver'").cutoff then
      level="silver"
    elsif merits.count>=academic_year.merit_cutoffs.find(:first, :conditions=>"level='bronze'").cutoff then
      level="bronze"
    else level="none"
    end
  end
  
  def count_generic_element_values(element_id, value, school_session_id=SchoolSession.current.id)
    #self.generic_report_element_data.select{|g| g.generic_report_element_id==element_id.to_i && g.report.setlink.pupil_set.school_session_id==school_session_id.to_i  && g.value  && g.value==value.to_s}.size
    GenericReportElementDatum.find_by_sql(["select generic_report_element_data.id \
                                            from generic_report_element_data, pupil_sets, \
                                            reports, setlinks, pupils \
                                                       WHERE pupils.id=? \
                                                       AND setlinks.pupil_id=pupils.id \
                                                       AND reports.setlink_id=setlinks.link_id \
                                                       AND generic_report_element_data.report_id=reports.id \
                                                       AND generic_report_element_data.generic_report_element_id=? \
                                                       AND setlinks.pupil_set_id=pupil_sets.id \
                                                       AND pupil_sets.school_session_id=? \
                                                       AND generic_report_element_data.value=?",self.id, element_id,school_session_id,value ]).size  
  end

end



