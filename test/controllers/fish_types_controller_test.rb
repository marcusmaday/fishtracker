require 'test_helper'

class FishTypesControllerTest < ActionController::TestCase
  setup do
    @fish_type = fish_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fish_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fish_type" do
    assert_difference('FishType.count') do
      post :create, fish_type: { name: @fish_type.name, point_value: @fish_type.point_value }
    end

    assert_redirected_to fish_type_path(assigns(:fish_type))
  end

  test "should show fish_type" do
    get :show, id: @fish_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fish_type
    assert_response :success
  end

  test "should update fish_type" do
    patch :update, id: @fish_type, fish_type: { name: @fish_type.name, point_value: @fish_type.point_value }
    assert_redirected_to fish_type_path(assigns(:fish_type))
  end

  test "should destroy fish_type" do
    assert_difference('FishType.count', -1) do
      delete :destroy, id: @fish_type
    end

    assert_redirected_to fish_types_path
  end
end
