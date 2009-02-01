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
class ValueListsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action=> 'list'
  end

  def list
    @value_list_pages, @value_lists = paginate :value_list, :per_page => 15, :conditions=>"end_date is null"
  end

  def show
    @value_list = ValueList.find(params[:id])
  end

  def new
    @value_list = ValueList.new
  end

  def create
    @value_list = ValueList.new(params[:value_list])
    if @value_list.save
      flash['notice'] = 'ValueList was successfully created.'
      redirect_to :action => 'edit', :id=>@value_list
    else
      render :action=> 'new'
    end
  end

  def edit
    @value_list = ValueList.find(params[:id])
  end

  def reorder_elements
    @value_list=ValueList.find(params[:id])
    @data=@value_list.value_list_data
    @data.length.times do |i|
       @datum=ValueListDatum.find(params[:list][i])
       @datum.item_order=i
       @datum.save
    end
    render :nothing=>true
  end
  
  def destroy
    ValueList.find(params[:id]).retire
    @flash[:notice] = 'Value List was successfully retired.'
    redirect_to :action => 'list'
  end
end
