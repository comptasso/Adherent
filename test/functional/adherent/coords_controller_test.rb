require 'test_helper'

module Adherent
  class CoordsControllerTest < ActionController::TestCase
    setup do
      @coord = coords(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:coords)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create coord" do
      assert_difference('Coord.count') do
        post :create, coord: { address: @coord.address, city: @coord.city, gsm: @coord.gsm, mail: @coord.mail, office: @coord.office, references: @coord.references, tel: @coord.tel, zip: @coord.zip }
      end
  
      assert_redirected_to coord_path(assigns(:coord))
    end
  
    test "should show coord" do
      get :show, id: @coord
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, id: @coord
      assert_response :success
    end
  
    test "should update coord" do
      put :update, id: @coord, coord: { address: @coord.address, city: @coord.city, gsm: @coord.gsm, mail: @coord.mail, office: @coord.office, references: @coord.references, tel: @coord.tel, zip: @coord.zip }
      assert_redirected_to coord_path(assigns(:coord))
    end
  
    test "should destroy coord" do
      assert_difference('Coord.count', -1) do
        delete :destroy, id: @coord
      end
  
      assert_redirected_to coords_path
    end
  end
end
