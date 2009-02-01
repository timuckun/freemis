require 'test_helper'

class GuidanceGroupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:guidance_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create guidance_group" do
    assert_difference('GuidanceGroup.count') do
      post :create, :guidance_group => { }
    end

    assert_redirected_to guidance_group_path(assigns(:guidance_group))
  end

  test "should show guidance_group" do
    get :show, :id => guidance_groups(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => guidance_groups(:one).id
    assert_response :success
  end

  test "should update guidance_group" do
    put :update, :id => guidance_groups(:one).id, :guidance_group => { }
    assert_redirected_to guidance_group_path(assigns(:guidance_group))
  end

  test "should destroy guidance_group" do
    assert_difference('GuidanceGroup.count', -1) do
      delete :destroy, :id => guidance_groups(:one).id
    end

    assert_redirected_to guidance_groups_path
  end
end
