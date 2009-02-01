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
class GenericReportElementsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action=> 'list'
  end

  def list
    @generic_report_element_pages, @generic_report_elements = paginate :generic_report_element, :per_page => 10
  end

  def show
    @generic_report_element = GenericReportElement.find(params[:id])
  end

  def new
    @generic_report_element = GenericReportElement.new
  end

  def create
    @generic_report_element = GenericReportElement.new(params[:generic_report_element])
    if @generic_report_element.save
      flash['notice'] = 'GenericReportElement was successfully created.'
      redirect_to :action => 'list'
    else
      render :action=> 'new'
    end
  end

  def edit
    @generic_report_element = GenericReportElement.find(params[:id])
  end

  def update
    @generic_report_element = GenericReportElement.find(params[:id])
    if @generic_report_element.update_attributes(params[:generic_report_element])
      flash['notice'] = 'GenericReportElement was successfully updated.'
      redirect_to :action => 'show', :id => @generic_report_element
    else
      render :action=> 'edit'
    end
  end

  def destroy
    GenericReportElement.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
