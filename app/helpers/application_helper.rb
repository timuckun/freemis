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
# The methods added to this helper will be available to all templates in the application.

module ApplicationHelper


  def object_selector(class_label)
    if class_label.respond_to?("find_for_selector") && class_label.respond_to?("selector_data")
      @objects=class_label.find_for_selector
      render :partial=>"shared/object_selector", :locals=>{:data=>class_label.selector_data}
    else 
      raise "You need to implement 'find_for_selector' and 'selector_data' in the model"
    end
  end
  
  def academic_year_selector
    @academic_years=AcademicYear.find(:all, :order=>"name")
    render :partial=>"shared/academic_year_select"
  end

  def set_selector(filter=false)
        filter="user" if Group.find(1).has_user(current_user) && !filter 
	filter="admin" if Group.find(2).has_user(current_user)
        @years=AcademicYear.find(:all, :order=>"name")
        case filter
            when "hod"
               @pupil_sets=current_user.faculty.current_pupil_sets rescue nil
            when "user" 
               @pupil_sets=current_user.current_pupil_sets rescue nil
            when "admin" 
               @pupil_sets=SchoolSession.current.pupil_sets rescue nil
            when "all"
                @pupil_sets=SchoolSession.current.pupil_sets rescue nil
        end
        render :partial=>"shared/setselect"
  end

  def user_selector
    @users=User.find(:all, :conditions=>"leave_date IS NULL", :order=>"lastname, firstname ASC")
    render :partial=>"shared/user_select"
  end
  
  # returns setlinks
  def pupil_selector(pupil_set_id,current_setlink="",auto_submit=true,show_submit=true)
    @pupils_with_setlinks=PupilSet.find(pupil_set_id).pupils.collect { |pupil| [pupil.full_name, pupil.link_id.to_s]}
    @current_setlink=current_setlink
    @auto_submit=auto_submit
    @show_submit=show_submit
    render :partial=>"shared/pupil_select_given_set"
  end

  ## Produces a set of <option....</option> tags to choose from a given
  ## value list (which is stored in the db).  Does NOT return the surrounding
  ## <select...</select> tags.
  def value_list_options(value_list,selected_value="",show_blank=true)
    return_string=""
    return_string="<option value=""></option>\n" if show_blank
    value_list.value_list_data.each do |item|
      return_string+="<option value=\"#{item.value_item}\""
      return_string+=" selected=\"selected\"" if item.value_item==selected_value
      return_string+=">#{item.value_item}</option>\n"
    end
    return return_string
  end

  def personalise(replacements_hash, text)
    this_text=text.dup
    replacements_hash.each do |key,value|
      this_text.gsub!(key.to_s,value.to_s)
    end
    return this_text
  end
end

class String

def capitalise_phrase
  ans=self.split.map!{|w| w.capitalize}.join(" ")
end
end
