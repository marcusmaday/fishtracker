require 'test_helper'

class CatchesControllerTest < ActionController::TestCase
  setup do
    @catch = catches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:catches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create catch" do
    assert_difference('Catch.count') do
      post :create, catch: { date: @catch.date, fish_type_id: @catch.fish_type_id, kept: @catch.kept, lat: @catch.lat, lon: @catch.lon, user_id: @catch.user_id }
    end

    assert_redirected_to catch_path(assigns(:catch))
  end

  test "should show catch" do
    get :show, id: @catch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @catch
    assert_response :success
  end

  test "should update catch" do
    patch :update, id: @catch, catch: { date: @catch.date, fish_type_id: @catch.fish_type_id, kept: @catch.kept, lat: @catch.lat, lon: @catch.lon, user_id: @catch.user_id }
    assert_redirected_to catch_path(assigns(:catch))
  end

  test "should destroy catch" do
    assert_difference('Catch.count', -1) do
      delete :destroy, id: @catch
    end

    assert_redirected_to catches_path
  end
end
