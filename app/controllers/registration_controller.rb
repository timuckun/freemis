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
class RegistrationController < ApplicationController
  before_filter :login_required
  def index
    welcome
    render :action=> 'welcome'
  end

  def register
    if params[:pupil_set]
      @pupil_set=PupilSet.find(params[:pupil_set])
    end
    if params[:newsetlink] && params[:period].to_s.length>0
      setlink=Setlink.find(params[:newsetlink])
      address=Organization.find(:first).email
      email=AbsenceMailer.deliver_notify(setlink,params[:period],current_user,address, params[:reason], params[:note][:extra])
      flash.now[:notice]="absence notification delivered"
    end
  end

end
