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
class InterimReportElementDataController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  def list
    @interim_report_element_datum_pages, @interim_report_element_data = paginate :interim_report_element_datum, :per_page => 10
  end

  def show
    @interim_report_element_datum = InterimReportElementDatum.find(params[:id])
  end

  def new
    @interim_report_element_datum = InterimReportElementDatum.new
  end

  def create
    @interim_report_element_datum = InterimReportElementDatum.new(params[:interim_report_element_datum])
    if @interim_report_element_datum.save
      flash[:notice] = 'InterimReportElementDatum was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @interim_report_element_datum = InterimReportElementDatum.find(params[:id])
  end

  def update
    @interim_report_element_datum = InterimReportElementDatum.find(params[:id])
    if @interim_report_element_datum.update_attributes(params[:interim_report_element_datum])
      flash[:notice] = 'InterimReportElementDatum was successfully updated.'
      redirect_to :action => 'show', :id => @interim_report_element_datum
    else
      render :action => 'edit'
    end
  end

  def destroy
    InterimReportElementDatum.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
