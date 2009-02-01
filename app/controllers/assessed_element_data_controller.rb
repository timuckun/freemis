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
class AssessedElementDataController < ApplicationController
  before_filter :login_required
  def index
    list
    render_:action=> 'list'
  end

  def list
    @assessed_element_datum_pages, @assessed_element_data = paginate :assessed_element_datum, :per_page => 10
  end

  def show
    @assessed_element_datum = AssessedElementDatum.find(params[:id])
  end

  def new
    @assessed_element_datum = AssessedElementDatum.new
  end

  def create
    @assessed_element_datum = AssessedElementDatum.new(params[:assessed_element_datum])
    if @assessed_element_datum.save
      flash['notice'] = 'AssessedElementDatum was successfully created.'
      redirect_to :action => 'list'
    else
      render_:action=> 'new'
    end
  end

  def edit
    @assessed_element_datum = AssessedElementDatum.find(params[:id])
  end

  def update
    @assessed_element_datum = AssessedElementDatum.find(params[:id])
    if @assessed_element_datum.update_attributes(params[:assessed_element_datum])
      flash['notice'] = 'AssessedElementDatum was successfully updated.'
      redirect_to :action => 'show', :id => @assessed_element_datum
    else
      render_:action=>'edit'
    end
  end

  def destroy
    AssessedElementDatum.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
