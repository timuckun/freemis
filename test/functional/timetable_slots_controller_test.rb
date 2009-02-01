require File.dirname(__FILE__) + '/../test_helper'
require 'timetable_slots_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class TimetableSlotsController; def rescue_action(e) raise e end; end

class TimetableSlotsControllerTest < Test::Unit::TestCase
  fixtures :timetable_slots, :users, :timetable_days, :timetable_periods

  def setup
    @controller = TimetableSlotsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("teacheruser")
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:timetable_slots)
  end

  def test_show
    get :show, :id =>4

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:timetable_slot)
    assert assigns(:timetable_slot).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:timetable_slot)
  end

  def test_create
    num_timetable_slots = TimetableSlot.count

    post :create, :timetable_slot => {:name=>"Period 10", :start_time=>{:hour=>18, :minute=>0}, :end_time=>{:hour=>19,:minute=>0}}
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_timetable_slots + 1, TimetableSlot.count
  end

  def test_edit
    get :edit, :id => 4

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:timetable_slot)
    assert assigns(:timetable_slot).valid?
  end

  def test_update
    post :update, :id => 4, :timetable_slot => {:name=>"Period 10", :start_time=>{:hour=>18, :minute=>0}, :end_time=>{:hour=>19,:minute=>0}}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 4
  end

  def test_destroy
    assert_not_nil TimetableSlot.find(4)

    post :destroy, :id => 4
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TimetableSlot.find(4)
    }
  end
end
