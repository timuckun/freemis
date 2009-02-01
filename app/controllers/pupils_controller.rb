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
class PupilsController < ApplicationController
  before_filter :login_required
  def index
    search
    render :action => 'search'
  end

  def reports
    @pupil = Pupil.find(params[:id])
    @reports=@pupil.reports
    @school_session=SchoolSession.current
  end

  def positives
    @pupil=Pupil.find(params[:id])
    @positives=@pupil.positives
  end

  def list
    @pupil_pages, @pupils = paginate :pupil, :per_page => 10
  end

  def show
    @pupil = Pupil.find(params[:id])
  end

  def new
    @pupil = Pupil.new
  end

  def search
    if params[:pupil] && params[:pupil][:name]!=""
      @pupils = Pupil.search( params[:pupil][:name].split.collect{ |c| "%#{c.downcase}%" } )
      if @pupils.length > 0
        render :action => 'list'
      else
        flash.now[:notice]='No pupils matched your search criteria.  Please try again'
      end
      #search for the pupil and return an array of pupil objects
      # the view will handle the displaying of the search form and the results
    end
  end

  def create
    @pupil = Pupil.new(params[:pupil])
    if @pupil.save
      flash['notice'] = 'Pupil was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @pupil = Pupil.find(params[:id])
  end

  def update
    @pupil = Pupil.find(params[:id])
    if @pupil.update_attributes(params[:pupil])
      flash['notice'] = 'Pupil was successfully updated.'
      redirect_to :action => 'show', :id => @pupil
    else
      render :action => 'edit'
    end
  end

  def destroy
    Pupil.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
