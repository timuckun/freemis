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
class ReportsController < ApplicationController
  before_filter :login_required
  def index
  end

  def full_edit
    @report = Report.find(:all, :conditions=>["setlink_id=?",params[:setlink_id]]).first if !@report
  end

  def write  #this writes full reports - if type of report is interim it does iterim instead
    if params[:type_of_report]=="interim"
      interim
      render :action=> "interim"
    else
      @auto_submit=true # pupil drop-down will auto_submit
      if params[:report]
        @report = Report.find(params[:id])
        @current_setlink=@report.setlink_id
        @pupil=@report.pupil
        @reports=@pupil.reports
        if @report.update_attributes(params[:report])
          flash.now[:notice]="#{@report.setlink.pupil.full_name}'s report was edited successfully"
        else
          flash.now[:notice]="There was a problem and your edits were not saved"
        end
      end
      if params[:pupil_set]
        @pupil_set=PupilSet.find(params[:pupil_set])
        @pupils_with_setlinks=@pupil_set.pupils.collect { |pupil| [pupil.full_name, pupil.link_id.to_s]}
        if params[:newsetlink] && params[:newsetlink].length>0  
            if @pupils_with_setlinks.last.last==params[:newsetlink]  #     if we are going to the last pupil in set
              @newsetlink=@pupils_with_setlinks.first.last                     #     then set the "next" button to link to first pupil
            else                                                                                     #     otherwise set "next" button to link th next pupil in set!
              @newsetlink=@pupils_with_setlinks[(@pupils_with_setlinks.index(@pupils_with_setlinks.detect{|p| p.last==params[:newsetlink].to_s})  || 0 )+1].last
            end
            #@newsetlink="34380005167"
          ## first find the report, otherwise create it.
          @report = Report.find(:first, :conditions=>"setlink_id=#{params[:newsetlink]}") || Report.new_with_associations(params[:newsetlink])
          @current_setlink=@report.setlink_id
          ## now add blank elements if any have been created since this report was created!
          @report.assessed_elements.each do |element|
           AssessedElementDatum.create({"report_id"=>@report.id,"assessed_element_id"=>element.id}) unless AssessedElementDatum.find(:first, :conditions=>["report_id=? and assessed_element_id=?",@report.id, element.id]) 
          end
          @report.reload
          @pupil=@report.pupil
          if session[:body] # ie if we have just come back from spell checking
            @report.reports_comment1=session[:body].to_s
            @report.save
            session[:body]=nil
          end
          #@reports=@pupil.reports
          #@reports=@reports.delete_if {|x| x.setlink_id==params[:newsetlink]}
        end
      end
      if params[:commit]=="Check Spelling" && params[:report] && params[:report]["reports_comment1"]!=""
        redirect_to :controller=>"spell", :action=>"check_spelling", :params=>{"return_controller"=>"reports", "return_action"=>"write", "body"=>params[:report][:reports_comment1], "return_params[pupil_set]"=>params[:pupil_set], "return_params[newsetlink]"=>@report.setlink.link_id}
      end
    end
  end

  def faculty_report_history
    @pupil=Pupil.find(params[:id])
    @pupil_set=PupilSet.find(params[:pupil_set_id])
    @faculty_reports =@pupil.faculty_reports(@pupil_set.course.faculty) rescue []
    if @faculty_reports.size>0
      render :update do |page|
        page.replace_html 'history', :partial =>'faculty_reports'
      end
    else
      render :nothing=>true
    end
  end
  
  def show_comment_bank
    @report=Report.find(params[:report_id])
    render :update do |page|
      page.replace_html 'comment_bank', :partial=>"report_comments/show_comment_bank", :object=>@report
      page.hide 'show_comments_div'
    end
  end

  def update
    @report = Report.find(params[:id])
    if @report.update_attributes(params[:report])
      flash[:notice] = 'Report was successfully updated.'
      redirect_to :action=> "write",  :params=>{"pupil_set"=>params[:pupil_set],"type_of_report"=>params[:type_of_report]}
    else
      render :action=> 'write'
    end
  end

  def write_interims
    if params[:pupil_set]
      @pupil_set=PupilSet.find(params[:pupil_set])
      @pupil_set_pages, @pupil_set_page=paginate_collection @pupil_set.pupils, {:page => params[:page], :per_page=>15}
      @interim_report_elements=@pupil_set.academic_year.interim_report_elements   
      render :action=>"print_interim_set", :layout=>"print_full_reports" if params[:commit]=="Print"
    end
  end

  def update_interims
    params[:setlink].to_a.each do |a|
      @setlink=Setlink.find(a.first)
      a.last.to_a.each do |element|
        if @element=@setlink.interim_report_element_data.find(:first, :conditions=>["interim_report_element_id=?",element.first])
        else
          @element=InterimReportElementDatum.new
          @element.interim_report_element_id=element.first
          @setlink.interim_report_element_data<<@element
          #@element=@setlink.interim_report_element_data.build()
        end
         @element.element_value=element.last
         @element.save
      end
    end
    flash[:notice] = 'Reports were successfully updated.'
    redirect_to :action=>"write_interims", :params=>{"pupil_set"=>params[:pupil_set], "page"=>params[:page], "commit"=>params[:commit]}
  end

  def print_one_full
    @report = Report.find(params[:id])
    render(:partial=>"print_one_full", :object=>@report, :layout=>"print_full_reports")
  end

  def print_full_pupil_set
    set_selector if !params[:pupils_set]
  end

  def summarize
    if params[:pupil_set]
      print_report_set_summary
      render :action=>'print_report_set_summary', :layout=>"print_full_reports"
    end
  end

  def print_full_collated_reports

  end
  
  def progress
    render :text=>session[:progress].to_s
  end

  def print_fcr_background
    if request.xhr?
       @guidance_group=GuidanceGroup.find(params[:guidance_group][:id])
       @pupils=@guidance_group.pupils
       @count=0
       @pupils.each do |pupil|
       @count+=1
         session[:progress]=@count/@pupils.length*100
         pupil[:report_array]=pupil.current_reports
         pupil[:guidance_report_data]=pupil.current_guidance_report
       end
       render :action=>"show_fcr", :layout=>"print_full_reports"
    end
  end
  
  def next_pupil_reports
    @guidance_group=GuidanceGroup.find(params[:guidance_group][:id])
    @pupil= params[:pupil_id] ? Pupil.find(params[:pupil_id]) : @guidance_group.pupils.first
    @pupil_position=@guidance_group.pupils.index(@pupil)
    @percentage_complete=(@pupil_position.to_f+1)/@guidance_group.pupils.size.to_f*100
    render:update do |page|
      page.replace_html( 'results', "") if @pupil==@guidance_group.pupils.first
      page.insert_html( :bottom,
                        'results',
                        :partial=>'pupil_reports')
      page.replace_html 'ajax_form_div', :partial=>'ajax_form'
      if @pupil==@guidance_group.pupils.last
        @completed=true
        page.replace_html 'ajax_form_div', :partial=>'ajax_form'
        page.replace_html 'completed', "All done!"
      else
        @pupil=@guidance_group.pupils[@pupil_position+1]
        page.replace_html 'ajax_form_div', :partial=>'ajax_form'
        page.replace_html 'completed', "Printing reports: #{@percentage_complete.to_i} % processed."
        page['submit_button'].click
      end    
    end
  end

  def print_report_set_summary
      @pupil_set=PupilSet.find(params[:pupil_set])
      @reports_array=[]
      @pupil_set.setlinks_sorted_by_pupil.each do |setlink|
        @reports_array.push setlink.report if setlink.report
      end
      @header_array=["Pupil"]
      @pupil_set.course.assessed_elements.each {|element| @header_array.push element.element.to_s }
      @pupil_set.academic_year.generic_report_elements.each {|element| @header_array.push element.element.to_s }
      @pupil_set.academic_year.full_report_elements.each { |element| @header_array.push element.element.to_s }
      @rows=[]
      @reports_array.each do |report|
        @row=[report.pupil.full_name]
        @pupil_set.course.assessed_elements.each do |element|
          element_datum=report.assessed_element_data.find(:first, :conditions=>["assessed_element_id=?",element.id])
          element_datum && element_datum.value !="NULL"  ? cell=element_datum.value : cell=""
          @row.push  cell
        end
        @pupil_set.academic_year.generic_report_elements.each do |element|
          element_datum=report.generic_report_element_data.find(:first, :conditions=>["generic_report_element_id=?",element.id])
          element_datum && element_datum.value !="NULL"  ? cell=element_datum.value : cell=""
          @row.push  cell
        end
        report.tracking_element_data.sort{|x,y| x.tracking_element.order <=>y.tracking_element.order}.each do |element|
            element.value !="NULL"  ? cell=element.value : cell=""
            @row.push  cell
        end
        @rows.push @row
      end
  end

  def view_faculty_reports
   # if params[:pupil_set]
   #    @pupil_set=PupilSet.find(params[:pupil_set]["id"])
   #    @reports=@pupil_set.setlinks.map { |setlink| setlink.report if setlink.report }
   #    @reports.delete(nil)
   #    @reports.sort! {|x,y| x.pupil.surname <=> y.pupil.surname }
   # end
   write
  end
  
  def print_set_reports
    if params[:pupil_set]
       @pupil_set=PupilSet.find(params[:pupil_set])
       @reports=@pupil_set.setlinks.map { |setlink| setlink.report if setlink.report }
       @reports.delete(nil)
       @reports.sort! {|x,y| x.pupil.surname <=> y.pupil.surname }
    end
  end


  def set_up_full_reports
    if params[:academic_year_id]
      @academic_year=AcademicYear.find(params[:academic_year_id])
    end
  end
  
  def analysis
    @academic_years=AcademicYear.find(:all, :order=>"name")
    @current_academic_year_id=flash[:academic_year_id]
    @current_element_id=flash[:element_id]
    if params[:academic_year_id]  && params[:academic_year_id]!=""
      flash[:academic_year_id]=params[:academic_year_id]
      @academic_year=AcademicYear.find(params[:academic_year_id])
    end
    if params[:element_id] && params[:element_id]!=""
      if @current_academic_year_id==params[:academic_year_id]
      flash[:academic_year_id]==params[:academic_year_id]
      flash[:element_id]=params[:element_id]
      @generic_report_element=GenericReportElement.find(params[:element_id])
      end
    end
    if params[:value] && params[:academic_year_id] && params[:element_id]  && params[:value]!=""
      if @current_element_id==params[:element_id] && @current_academic_year_id==params[:academic_year_id]
        @pupils=Pupil.find(:all, :conditions=>["academic_year_id=?",params[:academic_year_id]]).map{|p| [p,p.count_generic_element_values(params[:element_id],params[:value])]}.sort_by{|x| x.last}.reverse  
        headers['Content-Type'] = "application/vnd.ms-excel" 
        headers['Content-Disposition'] = 'attachment; filename="report analysis.csv"'
        headers['Cache-Control'] = ''
        render :partial=>"analysis_export", :layout => false
      end
    end
  end

## interim report methods

  def print_interim
    @school_session||=SchoolSession.current
    if @guidance_group=GuidanceGroup.find(params[:guidance_group_id]) && @guidance_group.pupils!=[] rescue nil
      @pupils=@guidance_group.pupils.select{|p| p.interim_report}
      render :partial=>"print_one_interim", :collection=>@pupils, :layout=>"print_full_reports", :spacer_template=>"shared/page_breaker"
    end
  end
end

