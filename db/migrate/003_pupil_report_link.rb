class PupilReportLink < ActiveRecord::Migration
  def self.up
  add_column "reports", "pupil_id", :integer
  execute "update reports, setlinks, pupils set reports.pupil_id=pupils.id where
           pupils.id=setlinks.pupil_id and setlinks.link_id=reports.setlink_id"
  end

  def self.down
    remove_column "reports", "pupil_id"
  end
end
