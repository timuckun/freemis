class LessonPlan < ActiveRecord::Base
  
  belongs_to :pupil_set
  belongs_to :timetable_slot
  
  def before_validation
    if LessonPlan.find(:first, :conditions=>["pupil_set_id=? and timetable_slot_id=? and lesson_date=?",pupil_set_id,timetable_slot_id,lesson_date])
      errors.add_to_base("A plan already exists for this lesson") 
      return false
    end
  end
  
end
