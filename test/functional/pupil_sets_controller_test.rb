require File.dirname(__FILE__) + '/../test_helper'
require 'pupil_sets_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class PupilSetsController; def rescue_action(e) raise e end; end

class PupilSetsControllerTest < Test::Unit::TestCase
  fixtures :pupil_sets, :users, :school_sessions, :academic_years, :courses, :course_levels

  def setup
    @controller = PupilSetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("teacheruser")
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'user_list'
  end

  def test_user_list
    get :user_list

    assert_response :success
    assert_template 'user_list'

    assert_not_nil assigns(:pupil_sets)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:pupil_set)
    assert assigns(:pupil_set).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

  end

  def test_create
    num_pupil_sets = PupilSet.count

    post :create, :pupil_set => {:set_code=>"1/MA/34", :academic_year_id=>"1", :course_id=>"1"}

    assert_response :redirect
    assert_redirected_to :action => 'show'

    assert_equal num_pupil_sets + 1, PupilSet.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:pupil_set)
    assert assigns(:pupil_set).valid?
  end

end
