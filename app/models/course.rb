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
class Course < ActiveRecord::Base
  has_many :pupil_sets
  has_many :assessed_elements, :order=>"element_order", :conditions=>"assessed_elements_end_date is NULL"
  has_many :report_comments
  belongs_to :course_level
  belongs_to :academic_year
  belongs_to :faculty
  has_many :tracking_element_data

  def Course.find_for_selector
    Course.find(:all, :order=>"course_code")
  end

  def Course.selector_data
    {"select_label"=>"--select a course--", "variable_name"=>"id", "display_column"=>"course_code"}
  end

  ## This extension of update_attributes allows for the direct updating of associated objects
  def update_attributes(attributes)
     if attributes["assessed_elements"]
      attributes["assessed_elements"].each do |key,value|
        @element=AssessedElement.find(key)
        @element.update_attributes(value)
      end
    end
    attributes.delete("assessed_elements")
    super(attributes)
    self.reload
  end

  def description
    self.academic_year.name + " " + self.course_subject + " " + self.course_level.name
  end

  def current_pupil_sets
    self.pupil_sets.find(:all, :conditions=>["pupil_set_end_date IS NULL and school_session_id=?",SchoolSession.current.id], :order=>"set_code")
  end
end
