require File.dirname(__FILE__) + '/../test_helper'
require 'tracking_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class TrackingController; def rescue_action(e) raise e end; end

class TrackingControllerTest < Test::Unit::TestCase
  fixtures :tracking_elements, :users, :school_sessions, :academic_years

  def setup
    @controller = TrackingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("teacheruser")
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'set_targets'
  end
  
  def test_display_oftracking_setup
    get :tracking_setup
    assert :success
    assert_template 'tracking_setup'
    
    get :tracking_setup, :academic_year_id=>"1"
    assert :success
    assert_template 'tracking_setup'
    assert_tag :content=>"Tracking Elements for S1 "
    
  end
  
  def test_update_tracking_element_via_tracking_setup_screen
    xhr :get, :edit_tracking_elements, :id=>"1", :academic_year=>{:tracking_elements=>{"1"=>{:element=>"Target"}}}
    assert :success
    assert_tag :tag=>"input", :attributes => {:id =>"academic_year_tracking_elements_1_element", :value =>"Target"}
  end
#
#  def test_list
#    get :list
#
#    assert_response :success
#    assert_template 'list'
#
#    assert_not_nil assigns(:tracking_elements)
#  end
#
#  def test_show
#    get :show, :id => 1
#
#    assert_response :success
#    assert_template 'show'
#
#    assert_not_nil assigns(:tracking_element)
#    assert assigns(:tracking_element).valid?
#  end
#
#  def test_new
#    get :new
#
#    assert_response :success
#    assert_template 'new'
#
#    assert_not_nil assigns(:tracking_element)
#  end
#
#  def test_create
#    num_tracking_elements = TrackingElement.count
#
#    post :create, :tracking_element => {}
#
#    assert_response :redirect
#    assert_redirected_to :action => 'list'
#
#    assert_equal num_tracking_elements + 1, TrackingElement.count
#  end
#
#  def test_edit
#    get :edit, :id => 1
#
#    assert_response :success
#    assert_template 'edit'
#
#    assert_not_nil assigns(:tracking_element)
#    assert assigns(:tracking_element).valid?
#  end
#
#  def test_update
#    post :update, :id => 1
#    assert_response :redirect
#    assert_redirected_to :action => 'show', :id => 1
#  end
#
#  def test_destroy
#    assert_not_nil TrackingElement.find(1)
#
#    post :destroy, :id => 1
#    assert_response :redirect
#    assert_redirected_to :action => 'list'
#
#    assert_raise(ActiveRecord::RecordNotFound) {
#      TrackingElement.find(1)
#    }
#  end
end
