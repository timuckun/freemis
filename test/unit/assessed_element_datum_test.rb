require File.dirname(__FILE__) + '/../test_helper'

class AssessedElementDatumTest < Test::Unit::TestCase
  fixtures :reports, :assessed_elements, :assessed_element_data

  def setup
    @assessed_element_datum = AssessedElementDatum.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of AssessedElementDatum,  @assessed_element_datum
  end
end
