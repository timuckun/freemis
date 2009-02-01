require File.dirname(__FILE__) + '/../test_helper'
require 'reports_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class ReportsController; def rescue_action(e) raise e end; end

class ReportsControllerTest < Test::Unit::TestCase
  fixtures :reports, :users, :groups, :groups_users, :pupil_sets, :courses, :school_sessions
  def setup
    @controller = ReportsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("teacheruser")
  end

  def test_write
    get :write
    assert_rendered_file 'write'
  end

  def test_get_set
   post :write, :pupil_set=>"1"
   assert_response :success
   assert_tag :tag=>"input", :attributes=>{:type=>"hidden", :name=>"pupil_set", :value=>"1"}
  end
  
  def test_show_analysis_choices
    
#    get :analysis
#    assert_response :success
#    assert_tag :tag=>"input", :attributes=>{:name=>"academic_year_id"}
#    
#    get :analysis, :academic_year_id=>"1"
#    assert_response :success
#    assert_tag :tag=>"input", :attributes=>{:name=>"element_id"}
#    
#    get :analysis, :academic_year_id=>"1", :element_id=>"1"
#    assert_response :success
#    assert_tag :tag=>"input", :attributes=>{:name=>"value"}
    
    get :analysis, :academic_year_id=>"1", :element_id=>"1", :value=>"1"
    assert_response :success
  end
  
end
