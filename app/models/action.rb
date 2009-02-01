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
class Action < ActiveRecord::Base
  has_and_belongs_to_many :groups, :join_table=>"accesses"

  def Action.actions(controller)
    Action.find(:all, :conditions=>"controller='#{controller}'")
  end

  def Action.find_controller_action(controller, action)
    Action.find(:first, :conditions => [ "controller = ? AND menu_action= ?", controller, action])
  end

  def accessible(thisUser)
    @accessible=nil
    for myGroup in self.groups do
      @accessible=1 if myGroup.has_user(thisUser)
    end
    return @accessible
  end
end
