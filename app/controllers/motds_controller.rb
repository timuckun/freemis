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
class MotdsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  def list
    @motd_pages, @motds = paginate :motd, :per_page => 10
    render(:layout=>false)
  end

  def show
    @motd = Motd.find(params[:id])
  end

  def new
    @motd = Motd.new
  end

  def create
    @motd = Motd.new(params[:motd])
    if @motd.save
      flash[:notice] = 'Motd was successfully created.'
      redirect_to :controller=>"top", :action => 'welcome'
    else
      render :action => 'new'
    end
  end

  def edit
    @motd = Motd.find(params[:id])
  end

  def update
    @motd = Motd.find(params[:id])
    if @motd.update_attributes(params[:motd])
      flash[:notice] = 'Motd was successfully updated.'
      redirect_to :action => 'show', :id => @motd
    else
      render :action => 'edit'
    end
  end

  def destroy
    Motd.find(params[:id]).destroy
    redirect_to :controller=>"top", :action => 'welcome'
  end
end
