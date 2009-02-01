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
class SchoolSessionsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  def list
    @school_session_pages, @school_sessions = paginate :school_session, :per_page => 10
  end

  def show
    @school_session = SchoolSession.find(params[:id])
  end

  def new
    @school_session = SchoolSession.new
    if  SchoolSession.find(:first)==nil
      render "school_sessions/first_new"
    end
  end

  def create
    @school_session = SchoolSession.new(params[:school_session])
    if @school_session.save
      flash[:notice] = 'SchoolSession was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @school_session = SchoolSession.find(params[:id])
    @school_sessions=SchoolSession.find(:all)
    if @school_session!=@school_sessions.last
      flash[:notice]="You can only edit the last school session in chronological order"
      redirect_to :action=>'list'
    end
  end

  def update
    @school_session = SchoolSession.find(params[:id])
    if @school_session.update_attributes(params[:school_session])
      flash[:notice] = 'SchoolSession was successfully updated.'
      redirect_to :action => 'show', :id => @school_session
    else
      render :action => 'edit'
    end
  end

  def destroy
    SchoolSession.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
