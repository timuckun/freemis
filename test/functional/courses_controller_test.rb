require File.dirname(__FILE__) + '/../test_helper'
require 'courses_controller'
include AuthenticatedTestHelper
# Re-raise errors caught by the controller.
class CoursesController; def rescue_action(e) raise e end; end

class CoursesControllerTest < Test::Unit::TestCase
  fixtures :courses, :assessed_elements, :users, :school_sessions

  def setup
    @controller = CoursesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("adminuser")
  end

  def test_index
    get :index
    assert_rendered_file 'edit'
  end


  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'course'
    assert_valid_record 'course'
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'course'
  end

  def test_create
    num_courses = Course.find_all.size

    post :create, 'course' => { }
    assert_redirected_to :action => 'edit'

    assert_equal num_courses + 1, Course.find_all.size
  end

  def test_edit
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'course'
    assert_valid_record 'course'
  end

  def test_update
    post :update, 'id' => 1, 'course'=>{:course_code=>"1/MA/4"}
    assert_redirected_to :id => "1", :action => 'edit' 
  end

  def test_retire_assessed_element
    get :retire_assessed_element, 'id'=>1, :element_id=>1
    assert_template "_assessed_elements_form"
    ending=AssessedElement.find(1).assessed_elements_end_date
    notending=AssessedElement.find(2).assessed_elements_end_date
    assert ending!=nil
    assert_equal notending, nil
  end
end
