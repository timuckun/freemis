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
class AcademicYear < ActiveRecord::Base
  has_many :generic_report_elements, :order=>"element_order", :conditions=>"generic_report_elements_end_date IS NULL"
  has_many :interim_report_elements, :order=>"`order`", :conditions=>"interim_report_elements_end_date IS NULL"
  has_many :tracking_elements, :order=>"element_order", :conditions=>"end_date IS NULL"
  has_many :pupils, :order=>"surname, known_as ASC", :conditions=>"leave_date IS NULL"
  has_many :merit_cutoffs
  has_many :guidance_report_elements, :conditions=>"end_date IS NULL"
  has_many :courses

  def visible_tracking_elements
    self.tracking_elements.find(:all, :conditions=>"visibility='on'")
  end

  def full_report_elements
    self.tracking_elements.find(:all, :conditions=>"show_full_report=1")
  end

  def interim_tracking_element
    self.tracking_elements.find(:first, :conditions=>"show_interim_report=1")
  end
  ## This extension of update_attributes allows for the direct updating of associated objects
  def update_attributes(attributes)
     if attributes["tracking_elements"]
      attributes["tracking_elements"].each do |key,value|
        @element=TrackingElement.find(key)
        @element.visibility="hide"
        @element.update_attributes(value)
      end
    end
    attributes.delete("tracking_elements")
      if attributes["generic_report_elements"]
      attributes["generic_report_elements"].each do |key,value|
        @element=GenericReportElement.find(key)
        @element.update_attributes(value)
      end
    end
    if attributes["interim_report_elements"]
      attributes["interim_report_elements"].each do |key,value|
        @element=InterimReportElement.find(key)
        @element.update_attributes(value)
      end
    end
    attributes.delete("generic_report_elements")
    attributes.delete("interim_report_elements")
    attributes.delete("tracking_elements")
    super(attributes)
    self.reload
  end
  #def interim_report_elements
  #  self.tracking_elements.find(:all, :conditions=>"show_interim_report=1")
  #end
end
