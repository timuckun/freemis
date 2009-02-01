class TimetablePeriod < ActiveRecord::Base
belongs_to :timetable_day
belongs_to :timetable_slot
has_many :lessons
has_many :pupil_sets, :through=>:lessons
validates_uniqueness_of :timetable_slot_id, :scope=>"timetable_day_id", :message=>"There is already a period in this slot on this day"
end
