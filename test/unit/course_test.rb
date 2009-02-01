require File.dirname(__FILE__) + '/../test_helper'

class CourseTest < Test::Unit::TestCase
  fixtures :courses

  def setup
    @course = Course.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Course,  @course
  end
end
