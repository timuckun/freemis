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
class SchoolSession < ActiveRecord::Base
# this model does "have many" pupil_sets, but this had to be done explicitly
# because of the way that SchoolSession.current is used in the conditions of pupil_sets
  has_many :pupil_sets, :order=>"set_code"
  def SchoolSession.current(date_at=Date.today)
    SchoolSession.find(:first, :conditions=>[ "school_session_start_date <= ? AND school_session_end_date>= ?", date_at, date_at ])
  end
  
  def validate
    unless school_session_end_date > school_session_start_date
      errors.add("The end date", " must be after the start date!")
    end
  end
  
  def SchoolSession.new(*params)
    @school_session=super(*params)
    @previous_session=SchoolSession.find(:first, :order=>"school_session_end_date DESC")
    @school_session.school_session_start_date=@previous_session.school_session_end_date+1 if @previous_session
    return @school_session
  end
end
