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
module ReportsHelper

  def show_interim_select (element,setlink,selected_value="",form="yes")
    data_element=Setlink.find(setlink).interim_report_element_data.find(:first, :conditions=> "interim_report_element_id=#{element.id}")
    selected_value= data_element.element_value if data_element
    if form=="yes"
      "<select name=\"setlink[#{setlink}][#{element.id}]\">"+value_list_options(element.value_list,selected_value)+"</select>"
    else
      selected_value.to_s.length>0 ? selected_value.to_s : "--"
    end
  end
end
