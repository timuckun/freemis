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
class ReportCommentsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  def list
    @report_comment_pages, @report_comments = paginate :report_comment, :per_page => 10
  end

  def show
    @report_comment = ReportComment.find(params[:id])
  end

  def new
    @report_comment = ReportComment.new
  end

  def create
    @report_comment = ReportComment.new(params[:report_comment])
    if @report_comment.save
      flash[:notice] = 'ReportComment was successfully created.'
    end
    @report=Report.find(params[:report_id])
    render :partial=>"show_comment_bank", :object=>@report
  end

  def edit
    @report_comment = ReportComment.find(params[:id])
  end

  def update
    @report_comment = ReportComment.find(params[:id])
    if @report_comment.update_attributes(params[:report_comment])
      flash[:notice] = 'ReportComment was successfully updated.'
      redirect_to :action => 'show', :id => @report_comment
    else
      render :action => 'edit'
    end
  end

  def destroy
    ReportComment.find(params[:id]).destroy
    @report=Report.find(params[:report_id])
    render :partial=>"show_comment_bank", :object=>@report
  end
end
