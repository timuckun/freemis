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
class GuidanceGroup < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :pupils, :order=>"surname,  known_as ASC "
  has_many :guidance_report_element_data

  def GuidanceGroup.find_for_selector
    GuidanceGroup.find(:all, :order=>"code")
  end
  
  def GuidanceGroup.selector_data
    {"select_label"=>"--select a group--", "variable_name"=>"guidance_group_id", "display_column"=>"code"}
  end

  def before_destroy
    errors.add("code", "this group has pupils in it!") unless pupils.size==0
  end
end