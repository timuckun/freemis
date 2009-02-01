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
require 'ajax_scaffold'

class Faculty < ActiveRecord::Base
  has_many :users, :order=>"surname"
  has_many :courses, :order=>"course_code ASC"

  def current_pupil_sets
    return_array=Array.new
    self.courses.each do |course|
      course.current_pupil_sets.each do |pupil_set|
        return_array << pupil_set
      end
    end
    return_array.sort! {|x,y| x.set_code <=> y.set_code }
  end


  def before_destroy
    if courses.length>0 || users.length>0
      errors.add "Can't destroy this faculty because there are courses and/or teachers allocated to it"
      false
    end
  end

end
