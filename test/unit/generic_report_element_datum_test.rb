require File.dirname(__FILE__) + '/../test_helper'

class GenericReportElementDatumTest < Test::Unit::TestCase
  fixtures :generic_report_element_data

  def setup
    @generic_report_element_datum = GenericReportElementDatum.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of GenericReportElementDatum,  @generic_report_element_datum
  end
end
