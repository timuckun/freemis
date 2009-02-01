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
class GuidanceReportsController < ApplicationController
  before_filter :login_required
  def index
    edit
    render :action => 'edit'
  end

  def list
    @guidance_report_pages, @guidance_reports = paginate :guidance_report, :per_page => 10
  end

  def show
    @guidance_report = GuidanceReport.find(params[:id])
  end

  def new
    @guidance_report = GuidanceReport.new
  end

  def create
    @guidance_report = GuidanceReport.new(params[:guidance_report])
    if @guidance_report.save
      flash[:notice] = 'GuidanceReport was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    if params[:id] && params[:id]!=""
      @guidance_report_to_update = GuidanceReport.find(params[:id])
      if @guidance_report_to_update.update_attributes(params[:guidance_report])
        flash.now[:notice] = "#{@guidance_report_to_update.pupil.full_name}'s Report was successfully updated."
      end
    end
     @groups=current_user.guidance_groups
     @guidance_group=GuidanceGroup.find(params[:guidance_group_id]) if params[:guidance_group_id]
     if params[:pupil_id] && params[:pupil_id]!=""
       @pupil=Pupil.find(params[:pupil_id])
       @guidance_report = GuidanceReport.find(:first, :conditions=>["pupil_id=? and school_session_id=?",params[:pupil_id], SchoolSession.current.id])
       @guidance_report=GuidanceReport.new({"pupil_id"=>params[:pupil_id],"school_session_id"=>SchoolSession.current.id}) if !@guidance_report
       @guidance_report.save
          @guidance_report.pupil.academic_year.guidance_report_elements.each do |element|
           GuidanceReportElementDatum.create({"guidance_report_id"=>@guidance_report.id,"guidance_report_element_id"=>element.id}) unless GuidanceReportElementDatum.find(:first, :conditions=>["guidance_report_id=? and guidance_report_element_id=?",@guidance_report.id, element.id]) 
          end
          @guidance_report.reload
    end
    if current_user.groups.include?(Group.find(5)) # ie if user is head teacher
      @groups=GuidanceGroup.find(:all)
      @principal=true
    end
  end

  def show_reports
    @pupil=Pupil.find(params[:id])
    render :partial=>'pupils/reports', :layout=>false
  end

  def update
    @guidance_report = GuidanceReport.find(params[:id])
    if @guidance_report.update_attributes(params[:guidance_report])
      flash[:notice] = 'GuidanceReport was successfully updated.'
      redirect_to :action => 'edit', :pupil_id=>params[:pupil_id], :guidance_group_id=>params[:guidance_group_id]
    else
      render :action => 'edit'
    end
  end

  def destroy
    GuidanceReport.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
