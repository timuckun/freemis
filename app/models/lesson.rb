class Lesson < ActiveRecord::Base
 belongs_to :pupil_set
 belongs_to :timetable_period
 has_and_belongs_to_many :users
 
 def teachers
 self.users!=[] ? self.users : self.pupil_set.users
 end
 
end
