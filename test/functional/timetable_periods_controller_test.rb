require File.dirname(__FILE__) + '/../test_helper'
require 'timetable_periods_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class TimetablePeriodsController; def rescue_action(e) raise e end; end

class TimetablePeriodsControllerTest < Test::Unit::TestCase
  fixtures :timetable_periods, :timetable_days, :timetable_slots, :users, :groups, :groups_users, :accesses

  def setup
    @controller = TimetablePeriodsController.new
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

    assert_not_nil assigns(:timetable_periods)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:timetable_period)
    assert assigns(:timetable_period).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:timetable_period)
  end

  def test_create
    num_timetable_periods = TimetablePeriod.count

    post :create, :timetable_period => {:timetable_day_id=>5, :timetable_slot_id=>7}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_timetable_periods + 1, TimetablePeriod.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:timetable_period)
    assert assigns(:timetable_period).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil TimetablePeriod.find(1)

    post :destroy, :id => 5
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TimetablePeriod.find(5)
    }
  end
end
