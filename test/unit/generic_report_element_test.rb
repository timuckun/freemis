require File.dirname(__FILE__) + '/../test_helper'

class GenericReportElementTest < Test::Unit::TestCase
  fixtures :generic_report_elements

  def setup
    @generic_report_element = GenericReportElement.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of GenericReportElement,  @generic_report_element
  end
end
