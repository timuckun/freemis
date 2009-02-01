require File.dirname(__FILE__) + '/../test_helper'

class InterimReportElementTest < Test::Unit::TestCase
  fixtures :interim_report_elements

  def setup
    @interim_report_element = InterimReportElement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of InterimReportElement,  @interim_report_element
  end
end
