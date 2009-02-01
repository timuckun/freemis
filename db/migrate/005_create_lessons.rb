class CreateLessons < ActiveRecord::Migration
  def self.up
    create_table :lessons do |t|
      # t.column :name, :string
    end
    create_table "lessons", :force =>true do |t|
      t.column "timetable_period_id", :integer
      t.column "pupil_set_id", :integer
      t.column "user_id", :integer
    end
    execute "insert into lessons (timetable_period_id,pupil_set_id) select * from pupil_sets_timetable_periods;"
    drop_table :pupil_sets_timetable_periods
  end

  def self.down
    create_table "pupil_sets_timetable_periods", :id=>false, :force =>true do |t|
      t.column "timetable_period_id", :integer
      t.column "pupil_set_id", :integer
    end
    execute "insert into pupil_sets_timetable_periods select timetable_period_id, pupil_set_id from lessons;"
    drop_table :lessons
  end
end
