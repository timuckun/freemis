class Gradebook < ActiveRecord::Migration
  def self.up
    create_table :gradebook_assessments, :force=>true do |t|
      t.column "pupil_set_id", :integer
      t.column "assessment_date", :date
      t.column "name", :string, :limit=>20
    end
    create_table :gradebook_scores, :force=>true do |t|
      t.column "pupil_id", :integer
      t.column "gradebook_assessment_id", :integer
      t.column "score", :string, :limit=>20
    end
  end

  def self.down
   drop_table :gradebook_assessments  
   drop_table :gradebook_scores  
  end
end
