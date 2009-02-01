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
class ParentalUnitsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  def list
    @parental_unit_pages, @parental_units = paginate :parental_unit, :per_page => 10
  end

  def show
    @parental_unit = ParentalUnit.find(params[:id])
  end

  def new
    @parental_unit = ParentalUnit.new
  end

  def create
    @parental_unit = ParentalUnit.new(params[:parental_unit])
    if @parental_unit.save
      flash[:notice] = 'ParentalUnit was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @parental_unit = ParentalUnit.find(params[:id])
  end

  def update
    @parental_unit = ParentalUnit.find(params[:id])
    if @parental_unit.update_attributes(params[:parental_unit])
      flash[:notice] = 'ParentalUnit was successfully updated.'
      redirect_to :action => 'show', :id => @parental_unit
    else
      render :action => 'edit'
    end
  end

  def destroy
    ParentalUnit.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
