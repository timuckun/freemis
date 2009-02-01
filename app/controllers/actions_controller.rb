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
class ActionsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  def list
    @action_pages, @actions = paginate :action, :per_page => 10
  end

  def show
    @action = Action.find(params[:id])
  end

  def new
    @action = Action.new
  end

  def create
    @action = Action.new(params[:action])
    if @action.save
      flash[:notice] = 'Action was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @action = Action.find(params[:id])
  end

  def update
    @action = Action.find(params[:id])
    if @action.update_attributes(params[:action])
      flash[:notice] = 'Action was successfully updated.'
      redirect_to :action => 'show', :id => @action
    else
      render :action => 'edit'
    end
  end

  def destroy
    Action.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
