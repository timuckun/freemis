require File.dirname(__FILE__) + '/../test_helper'

class AssessedElementTest < Test::Unit::TestCase
  fixtures :assessed_elements

  def setup
    @assessed_element = AssessedElement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of AssessedElement,  @assessed_element
  end
end
