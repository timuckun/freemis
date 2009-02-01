class GradebookAssessment < ActiveRecord::Base
  validates_uniqueness_of :name, :scope=>"pupil_set_id"
  validates_presence_of :name
  belongs_to :pupil_set
  has_many :gradebook_scores, :dependent=>:destroy
  
end
