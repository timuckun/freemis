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
module TrackingHelper

 def show_tracking_select (element,setlink_id,pupil_id,selected_value="")
    setlink=Setlink.find(setlink_id)
    data_element=Pupil.find(pupil_id).tracking_element_data.find(:first, :conditions=> ["tracking_element_id=? and course_id=? and school_session_id=?",element.id,setlink.pupil_set.course.id, setlink.pupil_set.school_session.id])
    selected_value= data_element.value if data_element
    "<select name=\"setlink[#{setlink_id}][#{element.id}]\">"+value_list_options(element.value_list,selected_value)+"</select>"
  end

  def show_pupil_targets(pupil, tracking_element)
  return_string="<table><tr><th>Subject</th><th>Level</th><th>Target</th></tr>\n"
  pupil.current_tracking_element_data.each do |datum|
    if (datum.tracking_element==tracking_element && datum.value!="")
      bit_string="<tr><td>#{datum.course.course_subject}</td><td align=\"center\">#{datum.course.course_level.code}</td><td align=\"center\">#{datum.value}</td></tr>"
      return_string+=bit_string
    end
  end
  return_string+="</table>"
  end
end
