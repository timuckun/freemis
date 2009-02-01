require File.dirname(__FILE__) + '/../test_helper'
require 'lesson_plans_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class LessonPlansController; def rescue_action(e) raise e end; end

class LessonPlansControllerTest < Test::Unit::TestCase
  fixtures :lesson_plans, :pupil_sets, :users, :timetable_periods, :lessons, :timetable_days, :timetable_slots

  def setup
    @controller = LessonPlansController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("teacheruser")
  end

  def test_index
    get :index, :pupil_set_id=>1
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list, :pupil_set_id=>1

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:lesson_plans)
  end

#  def test_show
#    get :show, :id => 1
#
#    assert_response :success
#    assert_template 'show'
#
#    assert_not_nil assigns(:lesson_plan)
#    assert assigns(:lesson_plan).valid?
#  end

  def test_new
    get :new, :pupil_set_id=>1

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:lesson_plan)
  end

  def test_create
    num_lesson_plans = LessonPlan.count

    post :create, :pupil_set_id=>1, :lesson_plan => {}, :lesson_chooser=>1

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_lesson_plans + 1, LessonPlan.count
  end

  def test_edit
    get :edit, :pupil_set_id => 1, :id=>1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:lesson_plan)
    assert assigns(:lesson_plan).valid?
  end

  def test_update
    post :update, :id => 1, :pupil_set_id=>1, :lesson_plan=>{}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil LessonPlan.find(1)

    post :destroy, :id => 2, :pupil_set_id=>1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      LessonPlan.find(2)
    }
  end
end
