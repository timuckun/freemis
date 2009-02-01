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
class TrackingElementsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  def list
    @tracking_element_pages, @tracking_elements = paginate :tracking_element, :per_page => 10
  end

  def show
    @tracking_element = TrackingElement.find(params[:id])
  end

  def new
    @tracking_element = TrackingElement.new
  end

  def create
    @tracking_element = TrackingElement.new(params[:tracking_element])
    if @tracking_element.save
      flash[:notice] = 'TrackingElement was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @tracking_element = TrackingElement.find(params[:id])
  end

  def update
    @tracking_element = TrackingElement.find(params[:id])
    if @tracking_element.update_attributes(params[:tracking_element])
      flash[:notice] = 'TrackingElement was successfully updated.'
      redirect_to :action => 'show', :id => @tracking_element
    else
      render :action => 'edit'
    end
  end

  def destroy
    TrackingElement.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
