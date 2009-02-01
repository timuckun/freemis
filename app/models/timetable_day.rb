require 'ajax_scaffold'

class TimetableDay < ActiveRecord::Base
  has_many :timetable_periods
  has_many :timetable_slots, :through=>:timetable_periods
  
  def timetable_period_for_slot(slot_id)
    self.timetable_periods.detect{|s| s.timetable_slot_id==slot_id}
  end
end
