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
class TrackingElementDataController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  def list
    @tracking_element_datum_pages, @tracking_element_data = paginate :tracking_element_datum, :per_page => 10
  end

  def show
    @tracking_element_datum = TrackingElementDatum.find(params[:id])
  end

  def new
    @tracking_element_datum = TrackingElementDatum.new
  end

  def create
    @tracking_element_datum = TrackingElementDatum.new(params[:tracking_element_datum])
    if @tracking_element_datum.save
      flash[:notice] = 'TrackingElementDatum was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @tracking_element_datum = TrackingElementDatum.find(params[:id])
  end

  def update
    @tracking_element_datum = TrackingElementDatum.find(params[:id])
    if @tracking_element_datum.update_attributes(params[:tracking_element_datum])
      flash[:notice] = 'TrackingElementDatum was successfully updated.'
      redirect_to :action => 'show', :id => @tracking_element_datum
    else
      render :action => 'edit'
    end
  end

  def destroy
    TrackingElementDatum.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
