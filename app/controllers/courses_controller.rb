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
class CoursesController < ApplicationController
  before_filter :login_required
  layout "application"
  def index
    edit
    render :action => 'edit'
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params[:course])
    if @course.save
      flash['notice'] = 'Course was successfully created.'
      redirect_to :action => 'edit'
    else
      render :action=>'new'
    end
  end

  def edit
      if params[:id]
        @course=Course.find(params[:id])
      end
  end

  def edit_assessed_elements
    @course=Course.find(params[:id])
    if @course.update_attributes(params[:course])
      flash.now[:local_notice]="Elements were successfully update"
      render :partial =>"assessed_elements_form"
    end
  end
  
  def new_assessed_element
    @course=Course.find(params[:id])
    @element=AssessedElement.create(:course_id=>@course.id, :start_date=>Time.now,  :element_order=>@course.assessed_elements.length+1)
    flash.now[:local_notice]="New Element Created"
    @course.reload
    render :partial =>"element_item", :object =>@element
  end
  
  def retire_assessed_element
    @course = Course.find(params[:id])
    @element=AssessedElement.find(params[:element_id])
    @element.assessed_elements_end_date=Time.now-50
    @element.save
    flash.now[:local_notice]="Element Deleted"
    render :partial=>"assessed_elements_form"
  end
  
  def reorder_assessed_elements
    @course = Course.find(params[:id])
    @elements=@course.assessed_elements
    @elements.length.times do |i|
       @element=AssessedElement.find(params[:list][i])
       @element.element_order=i
       @element.save
    end
    render :nothing=>true
  end
  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      flash[:notice] = 'Course was successfully updated.'
    end
    redirect_to :action=> 'edit', :id=>params[:id]
  end

  def edit_element_value_list
    @element=AssessedElement.find(params[:id])
    @element.update_attributes(params[:course_assessed_elements][params[:id]])
    render :nothing=>true
  end
#  def destroy
#    Course.find(params[:id]).destroy
#    redirect_to :action => 'list'
#  end
end
