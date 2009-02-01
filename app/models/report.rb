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
class Report < ActiveRecord::Base
  belongs_to :setlink, :foreign_key => "setlink_id"
  has_many :assessed_element_data
  has_many :generic_report_element_data
  has_many :specific_report_element_data
  belongs_to :pupil
  belongs_to :school_session

  def tracking_element_data
    track_data=Array.new
    self.setlink.pupil_set.academic_year.full_report_elements.each do |tracking|
      datum=self.pupil.tracking_element_data.find(:first, :conditions=>"tracking_element_id=#{tracking.id} AND course_id=#{self.setlink.pupil_set.course.id} and school_session_id= #{self.setlink.pupil_set.school_session_id}")
      track_data << datum if datum
    end
    return track_data
  end

  
  def update_attributes(attributes)
     if attributes["assesseds"]
      attributes["assesseds"].each do |key,value|
        @element=AssessedElementDatum.find(key)
        @element.update_attributes(value)
      end
    end
    if attributes["generics"]
      attributes["generics"].each do |key,value|
        @element=GenericReportElementDatum.find(key)
        @element.update_attributes(value)
      end
    end
    if attributes["specifics"]
      attributes["specifics"].each do |key,value|
        @element=SpecificReportElementDatum.find(key)
        @element.update_attributes(value)
      end
    end
    attributes.delete("generics")
    attributes.delete("assesseds")
    attributes.delete("specifics")
    super(attributes)
    self.reload
  end

  def course
    return self.setlink.pupil_set.course
  end

  def assessed_elements
    return self.setlink.pupil_set.course.assessed_elements.find(:all, :conditions=>"assessed_elements_end_date IS NULL")
  end

  def generic_report_elements
    return self.setlink.pupil_set.academic_year.generic_report_elements.find(:all, :conditions=>"generic_report_elements_end_date IS NULL")
  end
  def report_comments
    return self.setlink.pupil_set.course.report_comments
  end

  def Report.new_with_associations(setlink_id)
      ##
      #    Extends the new class method to create associated assessed and generic element data records
      #
      #
      ##
      @setlink=Setlink.find(setlink_id)
      @report=Report.new({"setlink_id"=>setlink_id, "pupil_id"=>@setlink.pupil_id, "school_session_id"=>@setlink.pupil_set.school_session_id})
      @report.save
      @report.assessed_elements.each do |element|
        AssessedElementDatum.new({"report_id"=>@report.id, "assessed_element_id"=>element.id}).save
      end
      @report.generic_report_elements.each do |element|
        GenericReportElementDatum.new({"report_id"=>@report.id, "generic_report_element_id"=>element.id}).save
      end
      @report
  end

  protected

  def check_ownership(id)
    if self.setlink.pupil_set.users.find(id)
      return true
    else
      return false
    end
  end

end
