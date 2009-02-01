require File.dirname(__FILE__) + '/../test_helper'

class InterimReportElementDatumTest < Test::Unit::TestCase
  fixtures :interim_report_element_data

  def setup
    @interim_report_element_datum = InterimReportElementDatum.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of InterimReportElementDatum,  @interim_report_element_datum
  end
end
