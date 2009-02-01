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
class InterimReportElementsController < ApplicationController
  before_filter :login_required
  def index
    setup
    render :action => 'setup'
  end

  ## The associated view gives the admin user a screen to choose an academic year
  ## and then edit the interim report elements that are available for that year.
  ## Any removals are non-destructive (by end_date) as we need to keep old elements
  ## for report histories.
  def setup
   if params[:id]
    @academic_year=AcademicYear.find(params[:id])
    
   end
  end
  def new
    @interim_report_element = InterimReportElement.new
  end

  def create
    @interim_report_element = InterimReportElement.new(params[:interim_report_element])
    if @interim_report_element.save
      flash[:notice] = 'InterimReportElement was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @interim_report_element = InterimReportElement.find(params[:id])
  end

  def update
    @interim_report_element = InterimReportElement.find(params[:id])
    if @interim_report_element.update_attributes(params[:interim_report_element])
      flash[:notice] = 'InterimReportElement was successfully updated.'
      redirect_to :action => 'show', :id => @interim_report_element
    else
      render :action => 'edit'
    end
  end

  def destroy
    InterimReportElement.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
