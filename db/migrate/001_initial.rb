class Initial < ActiveRecord::Migration
  def self.up
create_table "academic_years", :force => true do |t|
    t.column "name", :string, :limit => 10, :default => "", :null => false
    t.column "interim_report_text", :text
  end

  create_table "accesses", :id => false, :force => true do |t|
    t.column "action_id", :integer, :limit => 8, :default => 0, :null => false
    t.column "group_id", :integer, :limit => 9, :default => 0, :null => false
  end

  add_index "accesses", ["group_id"], :name => "group_id"

  create_table "actions", :force => true do |t|
    t.column "menu_text", :string, :limit => 30, :default => "", :null => false
    t.column "menu_order", :integer, :limit => 8, :default => 0, :null => false
    t.column "menu_action", :string, :limit => 30
    t.column "controller", :string, :limit => 50, :default => "", :null => false
  end

  create_table "assessed_element_data", :force => true do |t|
    t.column "report_id", :integer, :limit => 8, :default => 0, :null => false
    t.column "assessed_element_id", :integer, :limit => 9, :default => 0, :null => false
    t.column "value", :string, :limit => 50, :default => "", :null => false
  end

  add_index "assessed_element_data", ["assessed_element_id"], :name => "assessed_element_id"
  add_index "assessed_element_data", ["report_id"], :name => "report_id"

  create_table "assessed_elements", :force => true do |t|
    t.column "course_id", :integer, :limit => 9, :default => 0, :null => false
    t.column "element", :string, :limit => 50, :default => "", :null => false
    t.column "element_order", :integer, :limit => 2, :default => 0, :null => false
    t.column "start_date", :date, :null => false
    t.column "assessed_elements_end_date", :date
    t.column "value_list_id", :integer, :limit => 9
  end

  add_index "assessed_elements", ["course_id"], :name => "course_id"

  create_table "course_levels", :force => true do |t|
    t.column "code", :string, :limit => 10, :default => "", :null => false
    t.column "name", :string, :limit => 50, :default => "", :null => false
    t.column "external_id", :integer
  end

  create_table "courses", :force => true do |t|
    t.column "external_id", :integer
    t.column "academic_year_id", :integer, :default => 0, :null => false
    t.column "course_code", :string, :limit => 30, :default => "", :null => false
    t.column "course_subject", :string, :limit => 100
    t.column "course_rubric", :string, :limit => 100
    t.column "course_department", :string, :limit => 30
    t.column "faculty_id", :integer, :default => 0, :null => false
    t.column "course_level", :string, :limit => 20, :default => "", :null => false
    t.column "course_level_id", :integer, :default => 0, :null => false
    t.column "start_date", :integer, :default => 0, :null => false
    t.column "end_date", :integer
    t.column "previous_course_id", :integer
  end

  add_index "courses", ["course_code"], :name => "code", :unique => true
  add_index "courses", ["academic_year_id"], :name => "academic_year_id"
  add_index "courses", ["course_level_id"], :name => "course_level_id"

  create_table "faculties", :force => true do |t|
    t.column "name", :string, :limit => 40, :default => "", :null => false
    t.column "code", :string, :limit => 10, :default => "", :null => false
  end

  create_table "generic_report_element_data", :force => true do |t|
    t.column "report_id", :integer, :limit => 10, :default => 0, :null => false
    t.column "generic_report_element_id", :integer, :limit => 10, :default => 0, :null => false
    t.column "value", :string, :limit => 10
    t.column "start_date", :integer, :default => 0, :null => false
    t.column "end_date", :integer
  end

  add_index "generic_report_element_data", ["report_id", "generic_report_element_id"], :name => "gred_reports_id"
  add_index "generic_report_element_data", ["generic_report_element_id"], :name => "generic_report_element_id"

  create_table "generic_report_elements", :force => true do |t|
    t.column "academic_year_id", :string, :limit => 5
    t.column "element", :string, :limit => 100, :default => "", :null => false
    t.column "element_order", :integer, :default => 0, :null => false
    t.column "start_date", :integer, :limit => 10, :default => 0, :null => false
    t.column "generic_report_elements_end_date", :integer, :limit => 10
    t.column "value_list_id", :integer, :limit => 9, :default => 0, :null => false
  end

  add_index "generic_report_elements", ["academic_year_id"], :name => "report_year_id"

  create_table "groups", :force => true do |t|
    t.column "name", :string, :limit => 50, :default => "", :null => false
    t.column "description", :text
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.column "user_id", :integer, :limit => 9, :default => 0, :null => false
    t.column "group_id", :integer, :limit => 9, :default => 0, :null => false
  end

  add_index "groups_users", ["user_id"], :name => "teacher_seq"

  create_table "guidance_groups", :force => true do |t|
    t.column "code", :string, :limit => 20, :default => "", :null => false
    t.column "name", :string, :limit => 50, :default => "", :null => false
  end

  create_table "guidance_groups_users", :id => false, :force => true do |t|
    t.column "guidance_group_id", :integer, :default => 0, :null => false
    t.column "user_id", :integer, :limit => 10, :default => 0, :null => false
    t.column "school_session_id", :integer, :default => 0, :null => false
  end

  add_index "guidance_groups_users", ["user_id"], :name => "user_id"

  create_table "guidance_report_element_data", :force => true do |t|
    t.column "guidance_report_id", :integer, :limit => 10, :default => 0, :null => false
    t.column "guidance_report_element_id", :integer, :limit => 10, :default => 0, :null => false
    t.column "value", :string, :limit => 10
    t.column "start_date", :integer, :default => 0, :null => false
    t.column "end_date", :integer
  end

  create_table "guidance_report_elements", :force => true do |t|
    t.column "academic_year_id", :integer, :default => 0, :null => false
    t.column "element", :string, :limit => 50, :default => "", :null => false
    t.column "values_name", :string, :limit => 50, :default => "", :null => false
    t.column "element_order", :integer, :limit => 2, :default => 0, :null => false
    t.column "start_date", :date
    t.column "end_date", :date
  end

  create_table "guidance_reports", :force => true do |t|
    t.column "pupil_id", :integer, :limit => 14, :default => 0, :null => false
    t.column "session", :string, :limit => 7
    t.column "school_session_id", :integer, :default => 0, :null => false
    t.column "reports_comment1", :text
    t.column "reports_comment2", :text
    t.column "updated_on", :integer, :default => 0, :null => false
  end

  create_table "interim_report_element_data", :force => true do |t|
    t.column "setlink_id", :integer, :limit => 14, :default => 0, :null => false
    t.column "interim_report_element_id", :integer, :limit => 10, :default => 0, :null => false
    t.column "element_value", :string, :limit => 10, :default => "", :null => false
    t.column "updated_at", :integer, :default => 0, :null => false
  end

  add_index "interim_report_element_data", ["setlink_id"], :name => "ired_reports_id"
  add_index "interim_report_element_data", ["interim_report_element_id"], :name => "ired_interim_report_element_id"

  create_table "interim_report_elements", :force => true do |t|
    t.column "academic_year_id", :integer, :limit => 9, :default => 0, :null => false
    t.column "element", :string, :limit => 100, :default => "", :null => false
    t.column "order", :integer, :default => 0, :null => false
    t.column "start_date", :integer, :default => 0, :null => false
    t.column "interim_report_elements_end_date", :integer
    t.column "value_list_id", :integer, :limit => 9, :default => 0, :null => false
  end

  create_table "letters", :force => true do |t|
    t.column "title", :string, :limit => 200, :default => "", :null => false
    t.column "tracking_element_id", :integer, :default => 0, :null => false
    t.column "text1", :text, :default => "", :null => false
    t.column "text2", :text, :default => "", :null => false
    t.column "text3", :text, :default => "", :null => false
  end

  create_table "merit_counts", :id => false, :force => true do |t|
    t.column "pupil_id", :integer, :default => 0, :null => false
    t.column "totals", :integer, :limit => 21, :default => 0, :null => false
  end

  add_index "merit_counts", ["pupil_id"], :name => "pupil_id"

  create_table "merit_cutoffs", :force => true do |t|
    t.column "level", :string, :limit => 20, :default => "", :null => false
    t.column "cutoff", :integer, :limit => 9, :default => 0, :null => false
    t.column "academic_year_id", :integer, :default => 0, :null => false
  end

  create_table "merits", :force => true do |t|
    t.column "setlink_id", :integer, :limit => 20, :default => 0, :null => false
    t.column "pupil_id", :integer, :default => 0, :null => false
  end

  add_index "merits", ["setlink_id"], :name => "setlink_id"

  create_table "motds", :force => true do |t|
    t.column "text", :text, :default => "", :null => false
    t.column "created_on", :timestamp
  end

  create_table "organizations", :force => true do |t|
    t.column "name", :string, :limit => 100, :default => "", :null => false
    t.column "address_1", :string, :limit => 100, :default => "", :null => false
    t.column "address_2", :string, :limit => 100, :default => "", :null => false
    t.column "email", :string, :limit => 50, :default => "", :null => false
  end

  create_table "parent_link", :id => false, :force => true do |t|
    t.column "parent_link_id", :integer, :limit => 20, :null => false
    t.column "parental_unit_id", :integer, :limit => 20, :default => 0, :null => false
    t.column "pupil_id", :integer, :limit => 20, :default => 0, :null => false
  end

  create_table "parental_units", :force => true do |t|
    t.column "names", :string, :limit => 80, :default => "", :null => false
  end

  create_table "positives", :force => true do |t|
    t.column "setlink_id", :integer, :limit => 15, :default => 0, :null => false
    t.column "poz_comment", :text, :default => "", :null => false
    t.column "printed", :integer, :limit => 4, :default => 0, :null => false
    t.column "user_id", :integer, :default => 0, :null => false
    t.column "pupil_id", :integer, :limit => 9, :default => 0, :null => false
    t.column "poz_subject", :string, :limit => 40, :default => "", :null => false
    t.column "poz_timestamp", :timestamp
    t.column "updated_at", :integer, :default => 0, :null => false
  end

  create_table "pupil_sets", :force => true do |t|
    t.column "external_id", :integer
    t.column "set_code", :string, :limit => 30, :default => ""
    t.column "academic_year_id", :integer, :limit => 9, :default => 0, :null => false
    t.column "set_subjectcode", :string, :limit => 30, :default => ""
    t.column "set_setlevel", :string, :limit => 10, :default => ""
    t.column "set_setyear", :string, :limit => 5, :default => ""
    t.column "school_session_id", :integer, :limit => 9, :default => 0, :null => false
    t.column "set_setsubject", :string, :limit => 40
    t.column "course_code", :string, :limit => 15
    t.column "course_id", :integer
    t.column "set_teacher_code", :string, :limit => 6
    t.column "set_teacher_id", :integer, :limit => 9, :default => 0
    t.column "pupil_set_start_date", :integer, :default => 0, :null => false
    t.column "pupil_set_end_date", :integer
  end

  add_index "pupil_sets", ["course_id"], :name => "course_id"

  create_table "pupils", :force => true do |t|
    t.column "known_as", :string, :limit => 30, :default => "", :null => false
    t.column "external_id", :integer
    t.column "surname", :string, :limit => 30, :default => "", :null => false
    t.column "gender", :string, :limit => 1, :default => "m", :null => false
    t.column "academic_year_id", :integer, :limit => 9, :default => 0
    t.column "guidance_group_id", :integer, :default => 0, :null => false
    t.column "leave_date", :integer, :limit => 20
    t.column "forename", :string, :limit => 20
    t.column "middle_names", :string, :limit => 50
    t.column "preferred_surname", :string, :limit => 20
    t.column "d_o_b", :date
    t.column "doctor_id", :integer
    t.column "home_language", :string, :limit => 20
    t.column "free_school_meal_status", :string, :limit => 20
    t.column "care_status", :string, :limit => 20
    t.column "religion", :string, :limit => 20
  end

  create_table "report_comments", :force => true do |t|
    t.column "course_id", :integer, :default => 0, :null => false
    t.column "comment_text", :text, :default => "", :null => false
    t.column "comment_order", :integer, :limit => 9, :default => 0, :null => false
  end

  add_index "report_comments", ["course_id"], :name => "course_id"

  create_table "reports", :force => true do |t|
    t.column "setlink_id", :integer, :limit => 20, :default => 0, :null => false
    t.column "reports_comment1", :text
    t.column "reports_comment2", :text
    t.column "last_edited", :timestamp
  end

  add_index "reports", ["setlink_id"], :name => "reports_setlink_id"

  create_table "school_sessions", :force => true do |t|
    t.column "name", :string, :limit => 5, :default => "", :null => false
    t.column "school_session_start_date", :date, :null => false
    t.column "school_session_end_date", :date, :null => false
  end

  create_table "sessions", :force => true do |t|
    t.column "sessid", :string, :limit => 32
    t.column "data", :text
  end

  add_index "sessions", ["sessid"], :name => "sessid"

  create_table "set_teacher_link", :id => false, :force => true do |t|
    t.column "set_teacher_link_id", :integer, :limit => 10, :null => false
    t.column "user_id", :integer, :limit => 9, :default => 0, :null => false
    t.column "pupil_set_id", :integer, :limit => 10, :default => 0, :null => false
    t.column "start_date", :integer, :default => 0, :null => false
    t.column "end_date", :integer
  end

  add_index "set_teacher_link", ["pupil_set_id"], :name => "set_id"
  add_index "set_teacher_link", ["user_id"], :name => "teacher_id"
  add_index "set_teacher_link", ["end_date"], :name => "end_date"

  create_table "setlinks", :id => false, :force => true do |t|
    t.column "pupil_set_id", :integer, :limit => 10, :default => 0, :null => false
    t.column "pupil_id", :integer, :limit => 10, :default => 0, :null => false
    t.column "link_id", :integer, :limit => 20, :null => false
    t.column "external_pupil_id", :integer
    t.column "external_pupil_set_id", :integer
    t.column "setlink_current", :integer, :limit => 6, :default => 1
    t.column "setlink_end_date", :integer
    t.column "setlink_start_date", :integer, :default => 0, :null => false
  end

  add_index "setlinks", ["pupil_id"], :name => "pupil_seq"
  add_index "setlinks", ["pupil_set_id"], :name => "set_seq"

  create_table "tracking_element_data", :force => true do |t|
    t.column "pupil_id", :integer, :default => 0, :null => false
    t.column "course_id", :integer, :default => 0, :null => false
    t.column "tracking_element_id", :integer, :default => 0, :null => false
    t.column "value", :string, :limit => 50
    t.column "setlink_id", :integer, :limit => 20, :default => 0, :null => false
    t.column "school_session_id", :integer, :limit => 9, :default => 0, :null => false
  end

  add_index "tracking_element_data", ["pupil_id", "course_id", "tracking_element_id", "school_session_id"], :name => "tracking_pupil_id", :unique => true

  create_table "tracking_elements", :force => true do |t|
    t.column "year_code", :string, :limit => 4, :default => "0", :null => false
    t.column "academic_year_id", :integer, :limit => 9, :default => 0, :null => false
    t.column "element", :string, :limit => 50, :default => "", :null => false
    t.column "value_list_id", :integer, :limit => 9, :default => 0, :null => false
    t.column "element_order", :integer, :limit => 2, :default => 0, :null => false
    t.column "visibility", :string, :limit => 5
    t.column "editability", :integer, :limit => 4, :default => 0, :null => false
    t.column "show_full_report", :integer, :limit => 4
    t.column "show_interim_report", :integer, :limit => 4
    t.column "start_date", :date, :null => false
    t.column "end_date", :date
  end

  create_table "users", :force => true do |t|
    t.column "external_id", :integer
    t.column "teacher_code", :string, :limit => 100, :default => ""
    t.column "firstname", :string, :limit => 100
    t.column "lastname", :string, :limit => 100
    t.column "title", :string, :limit => 30
    t.column "login", :string, :limit => 20
    t.column "teacher_department", :string
    t.column "teacher_code", :string
    t.column "token_expiry", :string
    t.column "delete_after", :string
    t.column "verified", :integer, :default => 0, :null => false
    t.column "email", :string, :limit => 40, :default => "", :null => false
    t.column "salt", :string, :limit => 40, :default => "", :null => false
    t.column "crypted_password", :string, :limit => 40
    t.column "role", :string, :limit => 40, :default => "", :null => false
    t.column "security_token", :string, :limit => 40, :default => "", :null => false
    t.column "token_expiry", :datetime
    t.column "deleted", :integer, :default => 0, :null => false
    t.column "teacher_department", :string, :limit => 10
    t.column "faculty_id", :integer, :default => 0, :null => false
    t.column "leave_date", :integer, :limit => 20
  end

  create_table "value_list_data", :force => true do |t|
    t.column "list_name", :string, :limit => 50, :default => "", :null => false
    t.column "value_item", :string, :limit => 50, :default => "", :null => false
    t.column "item_order", :float, :default => 0.0, :null => false
    t.column "start_date", :integer, :default => 0, :null => false
    t.column "end_date", :integer
    t.column "value_list_id", :integer, :limit => 9, :default => 0, :null => false
  end

  add_index "value_list_data", ["value_list_id"], :name => "value_list_id"

  create_table "value_lists", :force => true do |t|
    t.column "name", :string, :limit => 80, :default => "", :null => false
    t.column "end_date", :integer
  end
  end

  def self.down
  end
end
