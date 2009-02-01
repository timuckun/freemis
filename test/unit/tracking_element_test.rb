require File.dirname(__FILE__) + '/../test_helper'

class TrackingElementTest < Test::Unit::TestCase
  fixtures :tracking_elements

  def setup
    @tracking_element = TrackingElement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of TrackingElement,  @tracking_element
  end
end
