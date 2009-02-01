require File.dirname(__FILE__) + '/../test_helper'

class TrackingElementDatumTest < Test::Unit::TestCase
  fixtures :tracking_element_data

  def setup
    @tracking_element_datum = TrackingElementDatum.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of TrackingElementDatum,  @tracking_element_datum
  end
end
