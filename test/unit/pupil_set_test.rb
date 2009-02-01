require File.dirname(__FILE__) + '/../test_helper'

class PupilSetTest < Test::Unit::TestCase
  fixtures :pupil_sets

  def setup
    @pupil_set = PupilSet.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of PupilSet,  @pupil_set
  end
end
