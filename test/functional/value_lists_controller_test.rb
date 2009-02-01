require File.dirname(__FILE__) + '/../test_helper'
require 'value_lists_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class ValueListsController; def rescue_action(e) raise e end; end

class ValueListsControllerTest < Test::Unit::TestCase
  fixtures :value_lists, :users, :school_sessions

  def setup
    @controller = ValueListsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("teacheruser")
  end

  def test_index
    get :index
    assert_rendered_file 'list'
  end

  def test_list
    get :list
    assert_rendered_file 'list'
    assert_template_has 'value_lists'
  end

  def test_show
    get :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'value_list'
    assert_valid_record 'value_list'
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'value_list'
  end

  def test_create
    num_value_lists = ValueList.find_all.size

    post :create, 'value_list' => {:name=>"testlist" }
    assert_redirected_to :action => 'edit'

    assert_equal num_value_lists + 1, ValueList.find_all.size
  end

  def test_edit
    get :edit, 'id' => 1
    assert_rendered_file 'edit'
    assert_template_has 'value_list'
    assert_valid_record 'value_list'
  end



  def test_destroy
    assert_not_nil ValueList.find(1)

    post :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

  end
end
