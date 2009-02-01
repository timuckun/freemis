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
class AssessedElementsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action=>'list'
  end

  def list
    @assessed_element_pages, @assessed_elements = paginate :assessed_element, :per_page => 10
  end

  def show
    @assessed_element = AssessedElement.find(params[:id])
  end

  def new
    @assessed_element = AssessedElement.new
  end

  def create
    @assessed_element = AssessedElement.new(params[:assessed_element])
    if @assessed_element.save
      flash['notice'] = 'AssessedElement was successfully created.'
      redirect_to :action => 'list'
    else
      render :action=>'new'
    end
  end

  def edit
    @assessed_element = AssessedElement.find(params[:id])
  end

  def update
    @assessed_element = AssessedElement.find(params[:id])
    if @assessed_element.update_attributes(params[:assessed_element])
      flash['notice'] = 'AssessedElement was successfully updated.'
      redirect_to :action => 'show', :id => @assessed_element
    else
      render :action=>'edit'
    end
  end

  def destroy
    AssessedElement.find(params[:id]).destroy
    redirect_to :action => 'list'
  endz
end
