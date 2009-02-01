require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'
include AuthenticatedTestHelper

# Raise errors beyond the default web-based presentation
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  
  fixtures :users, :school_sessions, :faculties
  
  def setup
    @controller = UserController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
    @request.host = "localhost"
  end
  
  

  
  def test_admin_change_password
    login_as("adminuser")
    post :admin_change_password
    assert :success
    assert_template "admin_change_password"
    
    post :admin_change_password, :user_id=>1000001
    assert :success
    assert_template "admin_change_password"
    assert_tag :tag=>"input", :attributes=>{:id=>"password"}
    
    post :admin_change_password, :user_id=>1000001, :password=>"password", :password_confirmation=>"password"
    assert_redirected_to :action=>"admin_change_password"
    
  end
  
  def test_admin_edit
    login_as("adminuser")
    post :admin_edit
    assert_success
    assert_template "admin_edit"
    
    post :admin_edit, :user_id=>1000001
    assert_template "admin_edit"
    assert_tag :tag=>"input", :attributes=>{:id=>"user_firstname", :value=>"bob"}
    assert_tag :tag=>"option", :attributes=>{:value=>"1", :selected=>"selected"}
    
    post :admin_edit, :id=>1000001, :user=>{:firstname=>"Ryan", :lastname=>"Smithers", :title=>"Dr", :faculty_id=>3}, :user_id=>1000007
    assert_redirected_to :action=>"show"
    assert_equal "User Details Edited.", flash[:notice]
  end
end
