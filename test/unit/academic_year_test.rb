require File.dirname(__FILE__) + '/../test_helper'

class AcademicYearTest < Test::Unit::TestCase
  fixtures :academic_years, :tracking_elements, :generic_report_elements, :generic_report_element_data
  
  def setup
    @academic_year = AcademicYear.find(1)
    @generic_report_element=GenericReportElement.find(1)
  end

  # Replace this with your real tests.
  def test_update_tracking_elements
    updated_year={"tracking_elements"=>{"1"=>{:element=>"New Name"}}}
    @academic_year.update_attributes(updated_year)
    assert_equal TrackingElement.find(1).element, "New Name"
    assert_equal TrackingElement.find(1).visibility, "hide" #the visibility of tracking elements is "hide" unless the input is checked    
    updated_year={"tracking_elements"=>{"1"=>{:element=>"New Name", :visibility=>"on"}}}
    @academic_year.update_attributes(updated_year)
    assert_equal TrackingElement.find(1).element, "New Name"
    assert_equal TrackingElement.find(1).visibility, "on" #making sure that checked elements are made visible
  end
  
  def test_summarize_counts_of_specified_generic_element_value_by_pupil
    #assert_equal @academic_year.summarize_counts_of_specified_generic_element_value_by_pupil("1","A").find(Pupil.find(1)).count_of_specified_generic_element_by_value("1","A")
  end
end
