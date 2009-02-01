require File.dirname(__FILE__) + '/../test_helper'

class SchoolSessionTest < Test::Unit::TestCase
  fixtures :school_sessions

  def setup
    @school_session = SchoolSession.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of SchoolSession,  @school_session
  end
end
