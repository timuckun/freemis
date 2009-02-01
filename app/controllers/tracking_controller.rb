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
class TrackingController < ApplicationController
  before_filter :login_required
  def index
    set_targets
    render :action=> "set_targets"
  end

  def tracking_setup
    if params[:academic_year_id]
      @academic_year=AcademicYear.find(params[:academic_year_id])
      @elements=@academic_year.tracking_elements
    end
  end
  
  def edit_tracking_elements
    @academic_year=AcademicYear.find(params[:id])
    if @academic_year.update_attributes(params[:academic_year])
      @elements=@academic_year.tracking_elements
      flash.now[:local_notice]="Elements were successfully update"
      render :partial =>"tracking_elements_form"
    end
  end
  
  def reorder_tracking_elements
    @academic_year = AcademicYear.find(params[:id])
    @elements=@academic_year.tracking_elements
    @elements.length.times do |i|
       @element=TrackingElement.find(params[:track_list][i])
       @element.element_order=i
       @element.save
    end
    render :nothing=>true
  end
  
  def new_tracking_element
    @academic_year=AcademicYear.find(params[:id])
    @element=TrackingElement.create(:academic_year_id=>@academic_year.id, :start_date=>Time.now,  :element_order=>@academic_year.tracking_elements.length+1)
    flash.now[:local_notice]="New Element Created"
    @academic_year.reload
    @elements=@academic_year.tracking_elements
    render :partial =>"element_item", :object=>@element
  end
  
  def retire_tracking_element
    @academic_year=AcademicYear.find(params[:id])
    @element=TrackingElement.find(params[:element_id])
    @element.end_date=Time.now-50
    @element.save
    @academic_year.reload
    @elements=@academic_year.tracking_elements
    flash.now[:local_notice]="Element Deleted"
    render :partial=>"tracking_elements_form"
  end
  

  def set_targets
    if params[:pupil_set]
      @has_target_elements=true
      @pupil_set=PupilSet.find(params[:pupil_set])
      @pupil_set_pages, @pupil_set_page=paginate_collection @pupil_set.pupils, {:page => params[:page], :per_page=>15}
      @tracking_elements=@pupil_set.academic_year.visible_tracking_elements
      unless @tracking_elements.length>0
        flash[:notice]="No tracking elements have been set up yet for #{@pupil_set.academic_year.name}"
        @has_target_elements=false
      end
    end
  end


  ## This is quite subtle.  Each time round the loop we check to see if
  ## a tracking element datum exists for the pupil/COURSE/session combination.
  ## If it does, we use update that.  It's crucial to do this rather than to just
  ## search for the setlink, because if a pupil moves to a different pupil_set doing
  ## the same course, the target (ie the tracking element datum) should move with them
  ## See also this approach in show_tracking_element helper.
  def update_targets
    params[:setlink].to_a.each do |a|
      @setlink=Setlink.find(a.first)
      a.last.to_a.each do |element|
        if @element=@setlink.pupil.tracking_element_data.find(:first, :conditions=>["tracking_element_id=? AND course_id=? AND school_session_id=?",element.first, @setlink.pupil_set.course.id, @setlink.pupil_set.school_session.id])
        else
          @element=TrackingElementDatum.new
          @element.tracking_element_id=element.first
          @element.pupil_id=@setlink.pupil.id
          @element.course_id=@setlink.pupil_set.course.id
          @element.school_session_id=@setlink.pupil_set.school_session.id
          @setlink.tracking_element_data<<@element
          #@element=@setlink.interim_report_element_data.build()
        end
         @element.value=element.last
         @element.save
      end
    end
    flash[:notice] = 'Targets were successfully updated.'
    redirect_to :action=>"set_targets", :params=>{"pupil_set"=>params[:pupil_set], "page"=>params[:page]}
  end

  def print_letters
    if params[:academic_year_id]
      @session_name=SchoolSession.current.name
      @academic_year=AcademicYear.find(params[:academic_year_id]) if params[:academic_year_id]
      @letters=Letter.find(:all)
    end
    @selected_letter=Letter.find(params[:letter_id]) if params[:letter_id] &&params[:letter_id]!="nil"
  end
  
  ## This action is used by admin to check which pupil_sets still have targets to be set for a given tracking_element
  def check_tracking_completion
      @letters=Letter.find(:all)
      if params[:letter_id]
        @element=Letter.find(params[:letter_id]).tracking_element
        @relevant_pupil_sets=PupilSet.find(:all, :conditions=>"school_session_id=#{SchoolSession.current.id} and academic_year_id=#{@element.academic_year_id}" )
        @result_pupil_sets=[]
        @relevant_pupil_sets.each do |pset|
          pset.pupils.each do |pupil|
            targets=TrackingElementDatum.find_by_sql(["select tracking_element_data.* from tracking_element_data  where 
                                                                          tracking_element_id=? and tracking_element_data.course_id=? and school_session_id=? and pupil_id=? order by value", @element.id, pset.course_id, SchoolSession.current.id, pupil.id])
            if targets.length==0  ||  targets.first.value==""
              @result_pupil_sets << pset
              break
            end
          end     
        end
      end
  end
  
  # This action produces a spreadsheet export of tracking data
  def analyse
    @year=AcademicYear.find_by_name("S4")
    @tracking_element=TrackingElement.find(17)
    @s3element=TrackingElement.find(5)
    @report_element=GenericReportElement.find(34)
    @pupils=AcademicYear.find_by_name("S4").pupils
    @courses=@year.courses.select{|course| course.tracking_element_data.select{|t| t.school_session_id==SchoolSession.current.id && t.tracking_element_id==17}.length>0}.map{|c| c.course_subject}.sort.uniq!
    @return_hash={}
    @pupils.each do |pupil|
      @return_hash[pupil.id]={}
      pupil.tracking_element_data.select{|t| t.tracking_element==@s3element}.each{|te| @return_hash[pupil.id][te.course.course_subject]=[te.value.to_s.gsub("\/","\\")]}
      pupil.tracking_element_data.select{|t| t.tracking_element==@tracking_element}.each{|te| @return_hash[pupil.id][te.course.course_subject]= (@return_hash[pupil.id][te.course.course_subject] || [nil]) << [te.value.to_s.gsub("\/","\\")]}
      pupil.generic_report_element_data.select{|g| g.generic_report_element_id==34}.each do |ge|
       if @return_hash[pupil.id][ge.report.setlink.pupil_set.course.course_subject]
        @return_hash[pupil.id][ge.report.setlink.pupil_set.course.course_subject]<< ge.value.to_s.gsub("\/","\\")
       else
         #it's all screwed up
       end
      end
    end
    content_type= if request.user_agent=~ /windows/i
                     'application/vnd.ms-excel'
                  else
                    'text/csv'
                  end
    CSV::Writer.generate(output= "") do |csv|
      @header=["'First Name'", "'Surname'", "'Register Class'"]
      @courses.each do |c| 
        @header << "'"+c+"'"
        @header<<nil
        @header<<nil
      end
      csv << @header
      @pupils.each do |p|
        @pupil_row=["'"+p.known_as+"'", "'"+p.surname+"'", "'"+p.guidance_group.code+"'"]
        @return_hash[p.id].each do |key,value|
          @pupil_row[@courses.index(key)*3+3]="'"+value[0].to_s+"'"
          @pupil_row[@courses.index(key)*3+4]="'"+value[1].to_s+"'"
          @pupil_row[@courses.index(key)*3+5]="'"+value[2].to_s+"'"
        end
        3.upto(3+@courses.length*3) do |i|
         @pupil_row[i]=nil unless @pupil_row[i]
        end
        csv<<@pupil_row
      end
    end
    send_data(output,
                :type => content_type,
                :filename => "data.csv")
    
    
    
  end
end
