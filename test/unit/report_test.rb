require File.dirname(__FILE__) + '/../test_helper'

class ReportTest < Test::Unit::TestCase
 fixtures :school_sessions
 fixtures :pupils
 fixtures :reports
 fixtures :pupil_sets
 fixtures :courses
 fixtures :assessed_elements
 fixtures :assessed_element_data
 fixtures :academic_years
 fixtures :generic_report_elements
 fixtures :generic_report_element_data
 
  def setup
     # create a new pupil, a new set and a link between them
    @new_set=pupil_sets(:first_pupil_set)
    @jimmy=pupils(:jimmy)
    @jimmy.add_to_set(@new_set)
    # create a report for this pupil <-> set link
    @new_report=Report.new_with_associations(@jimmy.pupil_sets.find(@new_set.id).link_id)
  end

  def test_create_with_associations

  # check that it exists
  assert_instance_of( Report, @new_report)

  # check that the assessed_elements have been referenced correctly by the model
  assert_equal(@new_report.assessed_elements, @new_set.course.assessed_elements)

  # check that there are the right number of associated assessed_element_data items
  assert_equal(@new_report.assessed_elements.length,@new_report.assessed_element_data.length)

 # check that the generic_elements have been referenced correctly by the model
  assert_equal(@new_report.generic_report_elements, @new_set.academic_year.generic_report_elements)

  # check that there are the right number of associated assessed_element_data items
  assert_equal(@new_report.generic_report_elements.length,@new_report.generic_report_element_data.length)
  end

  def test_update_attributes
    @assesseds=Hash.new
    @new_report.assessed_element_data.each do |element|
      @assesseds=@assesseds.merge({element.id.to_s=>{"value"=>element.id.to_s}})
    end
    @generics=Hash.new
     @new_report.generic_report_element_data.each do |element|
      @generics=@generics.merge({element.id.to_s=>{"value"=>element.id.to_s}})
    end
    attributes={"id"=>@new_report.id, "reports_comment1"=>"Good work Jimmy Boy", "assesseds"=>@assesseds, "generics"=>@generics}

    @new_report.update_attributes(attributes)
    assert_equal(@new_report.reports_comment1,"Good work Jimmy Boy")
    @new_report.assessed_element_data.each do |element|
      assert_equal(element.id.to_s, element.value.to_s)
    end
    @new_report.generic_report_element_data.each do |element|
      assert_equal(element.id.to_s, element.value.to_s)
    end
  end
  

end
