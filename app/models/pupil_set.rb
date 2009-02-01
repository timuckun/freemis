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
class PupilSet < ActiveRecord::Base

  validates_presence_of :school_session_id, :course_id, :academic_year_id, :set_code,
                                       :message=>"please enter data into all fields before creation"
  validates_uniqueness_of :set_code, :scope =>"school_session_id",
                                          :message=>"There is already a pupil set with this name this session."
  
  has_and_belongs_to_many :pupils, :join_table => "setlinks", :order=>"surname, known_as ASC", :conditions=>"setlink_end_date IS NULL"
  has_many :set_teacher_links
  has_many :users, :through=>:set_teacher_links, :conditions=>"set_teacher_link.end_date IS NULL" do
    def push_with_attributes(user, join_attrs)
      SetTeacherLink.send(:with_scope, :create => join_attrs) { self << user }
    end
  end

  belongs_to :course
  has_many :setlinks, :conditions=>"setlink_end_date IS NULL"
  belongs_to :academic_year
  belongs_to :school_session
  has_many :lessons
  has_many :timetable_periods, :through=> :lessons, :include=>[:timetable_slot, :timetable_day], :order=>"timetable_periods.id ASC"
  has_many :gradebook_assessments, :order=>"assessment_date ASC"
  
  def drop(user)
    self.users.delete(user)
    self.users.push_with_attributes(user,{"end_date"=>Time.now.to_i})
  end

  def add(user)
    self.users.push_with_attributes(user,{"start_date"=>Time.now.to_i, "end_date"=>nil}) unless self.users.include?(user)
  end

  def setlinks_sorted_by_pupil
    links=self.setlinks.sort {|x,y| x.pupil.surname.to_s + x.pupil.known_as.to_s <=> y.pupil.surname.to_s + y.pupil.known_as.to_s }
    links.reject{|link| link.setlink_end_date}
  end
  
  def next_meeting(time=Time.now)   
    date=Date.new(time.year, time.mon, time.day)
    return nil unless date<= SchoolSession.current.school_session_end_date and date>= SchoolSession.current.school_session_start_date
    self.timetable_periods.each do |period|
      if period.timetable_slot.name==time.strftime("%A") and [period.timetable_slot.end_time.hour,period.timetable_slot.end_time.min]<=[time.hour,time.min]
        return period
      end
    end
    #return nil
  end
  
  def meetings
    meetings_array=[]
    counter=0
    self.school_session.school_session_start_date.upto(self.school_session.school_session_end_date) do |session_day|
      self.timetable_periods.each do |tp|
        if tp.timetable_day.name==session_day.strftime("%A")
          meetings_array<<{:index=>counter, :meeting_date=>session_day, :timetable_slot=>tp.timetable_slot} 
          counter+=1
        end
      end
    end
    meetings_array
  end

end
