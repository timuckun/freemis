require File.dirname(__FILE__) + '/../test_helper'

class PositiveTest < Test::Unit::TestCase
  fixtures :positives

  def setup
    @positive = Positive.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Positive,  @positive
  end
end
