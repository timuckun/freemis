require File.dirname(__FILE__) + '/../test_helper'
require 'pupils_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class PupilsController; def rescue_action(e) raise e end; end

class PupilsControllerTest < Test::Unit::TestCase
  fixtures :pupils, :users, :school_sessions

  def setup
    @controller = PupilsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("adminuser")
  end

  def test_index
    get :index
    assert_rendered_file 'search'
  end


  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'pupil'
    assert_valid_record 'pupil'
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'pupil'
  end

  def test_create
    num_pupils = Pupil.find_all.size

    post :create, 'pupil' => {:known_as=>"Paul", :surname=>"Smith", :gender=>"m", :academic_year_id=>"1", :guidance_group_id=>"1" }
    assert_redirected_to :action => 'list'

    assert_equal num_pupils + 1, Pupil.find_all.size
  end

  def test_edit
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'pupil'
    assert_valid_record 'pupil'
  end

  def test_update
    post :update, 'id' => 1
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Pupil.find(100003)

    post :destroy, 'id' => 100003
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      pupil = Pupil.find(100003)
    }
  end
end
