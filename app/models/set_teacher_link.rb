class SetTeacherLink < ActiveRecord::Base
  self.table_name='set_teacher_link'
  set_primary_key "set_teacher_link_id"
  belongs_to :user
  belongs_to :pupil_set
end
