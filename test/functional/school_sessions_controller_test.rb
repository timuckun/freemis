require File.dirname(__FILE__) + '/../test_helper'
require 'school_sessions_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class SchoolSessionsController; def rescue_action(e) raise e end; end

class SchoolSessionsControllerTest < Test::Unit::TestCase
  fixtures :school_sessions, :users

  def setup
    @controller = SchoolSessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("adminuser")
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

    assert_not_nil assigns(:school_sessions)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:school_session)
    assert assigns(:school_session).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:school_session)
  end

  def test_create
    num_school_sessions = SchoolSession.count

    post :create, :school_session => {:school_session_end_date => "2100/05/05", :name => "testsesh"}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_school_sessions + 1, SchoolSession.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :redirect
    assert_redirected_to :action=> 'list'

   
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil SchoolSession.find(2)

    post :destroy, :id => 2
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      SchoolSession.find(2)
    }
  end
end
