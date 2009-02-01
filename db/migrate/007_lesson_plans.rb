class LessonPlans < ActiveRecord::Migration
  def self.up
   create_table :lesson_plans, :force=>true do |t|
      t.column "pupil_set_id", :integer
      t.column "lesson_date", :date
      t.column "timetable_slot_id", :integer
      t.column "aim", :text
      t.column "objectives", :text
      t.column "lesson", :text
    end
  end

  def self.down
    drop_table :lesson_plans
  end
end
