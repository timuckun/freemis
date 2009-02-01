class ReportSessions < ActiveRecord::Migration
  def self.up
   add_column "reports", "school_session_id", :integer
   execute "update reports, setlinks, pupil_sets set reports.school_session_id=pupil_sets.school_session_id where reports.setlink_id=setlinks.link_id and setlinks.pupil_set_id=pupil_sets.id;"
  end

  def self.down
    remove_column "reports", "school_session_id"
  end
end
