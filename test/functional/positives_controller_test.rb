require File.dirname(__FILE__) + '/../test_helper'
require 'positives_controller'
include AuthenticatedTestHelper
# Re-raise errors caught by the controller.
class PositivesController; def rescue_action(e) raise e end; end

class PositivesControllerTest < Test::Unit::TestCase
  fixtures :positives, :users, :groups, :groups_users, :school_sessions, :pupil_sets, :set_teacher_link, :pupils, :setlinks, :guidance_groups

    def setup
    @controller = PositivesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("teacheruser")
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'classpos'
    assert_tag :tag=>"select", :attributes=>{:id=>"pupil_set"}
  end


  def test_class_pos_shows_pupil_list
    get :classpos, :pupil_set=>1
    assert_response :success
    assert_template 'classpos'
    assert_tag :tag=>"select", :attributes=>{:id=>"pupil_set"}
    assert_tag :tag=>"select", :attributes=>{:id=>"newsetlink"}
  end

  def test_class_pos_shows_pos_once_pupil_selected
    get :classpos, :pupil_set=>1, :newsetlink=>1
    assert_response :success
    assert_template 'classpos'
    assert_tag :tag=>"select", :attributes=>{:id=>"pupil_set"}
    assert_tag :tag=>"select", :attributes=>{:id=>"newsetlink"}
    assert_tag :tag=>"form", :attributes=>{:action=>"/positives/create/"}
  end

#   def test_new
#     get :new
# 
#     assert_response :success
#     assert_template 'new'
# 
#     assert_not_nil assigns(:positive)
#   end

  def test_create
    num_positives = Positive.count
    user_id=User.find(1000007).id
    post :create, :positive => {:poz_comment=>"Well done lad", :poz_subject=>"Mathematics S1", :setlink_id=>1, :pupil_id=>  100003,  :user_id=>user_id}, :newsetlink=>1, "pupil-set"=>1, :pupil_set_id=>1
    assert_response :redirect
    assert_redirected_to :action => 'classpos', :newsetlink=>1, :pupil_set=>1
    assert_equal num_positives + 1, Positive.count
    assert_equal 'Positive was successfully created.', flash[:notice]
    follow_redirect
    assert_tag :tag=>"td", :child=> /Well done lad/
  end

  def test_edit
    get :edit, :id => 2
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:positive)
    assert assigns(:positive).valid?
  end

  def test_update
    post :update, :id => 2, :newsetlink=>1, :positive=>{:poz_comment=>"Genius effort"}
    assert_response :redirect
    assert_equal flash[:notice], 'Positive was successfully edited.'
    assert_redirected_to :action => 'classpos', :pupil_set => assigns["positive"].setlink.pupil_set.id, :newsetlink=>1
    follow_redirect
    assert_tag :tag=>"td", :child=> /Genius effort/
  end

  def test_destroy
    assert_not_nil Positive.find(1)
    post :destroy, :id => 1, :newsetlink=>1, :pupil_set=>1
    assert_response :redirect
    assert_redirected_to :action => 'classpos'
    assert_raise(ActiveRecord::RecordNotFound) {
      Positive.find(1)
    }
  end
end
