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
class AcademicYearsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action=>'list'
  end

  def set_up_generic_report_elements
    @academic_year ||=AcademicYear.find(params[:id])
    render :partial=>"academic_years/set_up_generic_reports"
  end

  def reorder_generic_report_elements
    @academic_year = AcademicYear.find(params[:id])
    @elements=@academic_year.generic_report_elements
    @elements.length.times do |i|
       @element=GenericReportElement.find(params[:genlist][i])
       @element.element_order=i
       @element.save
    end
    render :nothing=>true
  end

  def edit_generic_report_elements
    @academic_year = AcademicYear.find(params[:id])
    if @academic_year.update_attributes(params[:academic_year])
      flash.now[:local_notice]="Elements were successfully update"
      render :partial=>"academic_years/set_up_generic_report_elements"
    end
  end

def new_generic_report_element
    @academic_year = AcademicYear.find(params[:id])
    @element=GenericReportElement.create(:academic_year_id=>@academic_year.id, :start_date=>Time.now,  :element_order=>@academic_year.generic_report_elements.length+1)
    flash.now[:local_notice]="New Element Created"
    @academic_year.reload
    render :partial =>"academic_years/set_up_generic_report_elements"
  end
  
  def retire_generic_report_element
    @academic_year = AcademicYear.find(params[:id])
    @element=GenericReportElement.find(params[:element_id])
    @element.generic_report_elements_end_date=Time.now-50
    @element.save
    flash.now[:local_notice]="Element Deleted"
    render :partial =>"academic_years/set_up_generic_report_elements"
  end

def edit_interim_report_elements
    @academic_year=AcademicYear.find(params[:id])
    if @academic_year.update_attributes(params[:academic_year])
      flash.now[:local_notice]="Elements were successfully update"
      render :partial =>"interim_report_elements_form"
    end
  end
  
  def new_interim_report_element
    @academic_year=AcademicYear.find(params[:id])
    @element=InterimReportElement.create(:academic_year_id=>@academic_year.id, :start_date=>Time.now,  :order=>@academic_year.interim_report_elements.length+1)
    flash.now[:local_notice]="New Element Created"
    @academic_year.reload
    render :partial =>"interim_report_elements_form"
  end
  
  def retire_interim_report_element
    @academic_year=AcademicYear.find(params[:id])
    @element=InterimReportElement.find(params[:element_id])
    @element.interim_report_elements_end_date=Time.now-50
    @element.save
    flash.now[:local_notice]="Element Deleted"
    render :partial=>"interim_report_elements_form"
  end
  
  def reorder_interim_report_elements
    @academic_year=AcademicYear.find(params[:id])
    @elements=@academic_year.assessed_elements
    @elements.length.times do |i|
       @element=InterimReportElement.find(params[:list][i])
       @element.order=i
       @element.save
    end
    render :nothing=>true
  end

  def list
    @academic_year_pages, @academic_years = paginate :academic_year, :per_page => 10
  end

  def show
    @academic_year = AcademicYear.find(params[:id])
  end

  def new
    @academic_year = AcademicYear.new
  end

  def create
    @academic_year = AcademicYear.new(params[:academic_year])
    if @academic_year.save
      flash['notice'] = 'AcademicYear was successfully created.'
      redirect_to :action => 'list'
    else
      render :action=>'new'
    end
  end

  def edit
    @academic_year = AcademicYear.find(params[:id])
  end

  def update
    @academic_year = AcademicYear.find(params[:id])
    params[:academic_year]["interim_report_text"].gsub!(/<\s*?script[^>]*?>.*?<\s*?\/script\s*?>/m, '') #remove javascript
    if @academic_year.update_attributes(params[:academic_year])
      flash[:notice] = 'Academic Year was successfully updated.'
      redirect_to :action => 'edit', :id => @academic_year
    else
      render :action=> 'edit'
    end
  end

  def destroy
    AcademicYear.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
