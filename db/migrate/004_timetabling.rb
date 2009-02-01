class Timetabling < ActiveRecord::Migration
  def self.up
    create_table "timetable_days", :force => true do |t|
      t.column "name", :string
      t.column "order", :integer
    end
    create_table "timetable_slots", :force => true do |t|
      t.column "name", :string
      t.column "start_time", :time
      t.column "end_time", :time
    end
    create_table "timetable_periods", :force => true do |t|
      t.column "timetable_day_id", :integer
      t.column "timetable_slot_id", :integer
    end
    create_table "pupil_sets_timetable_periods", :id=>false, :force =>true do |t|
      t.column "timetable_period_id", :integer
      t.column "pupil_set_id", :integer
    end
  end

  def self.down
    drop_table "timetable_days"
    drop_table "timetable_slots"
    drop_table "timetable_periods"
    drop_table "pupil_sets_timetable_periods"
  end
end
