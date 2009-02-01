class GradebookScore < ActiveRecord::Base

  belongs_to :gradebook_assessment
  belongs_to :pupil
  
end
