require 'test_helper'

module Adherent
  class CoordsControllerTest < ActionController::TestCase
    setup do
      @coord = adherent_coords(:one)
      @member = adherent_members(:one)
    end
  
    test "should get index" do
      get :index, use_route: :adherent
      assert_response :success
      assert_not_nil assigns(:coords)
    end
  
    test "should get new" do
      
      get :new, member_id:@member.to_param, use_route: :adherent
      assert_response :success
    end
  
    test "should create coord" do
      assert_difference('Coord.count') do
        post :create, {member_id:@member, coord: { address: @coord.address, city: @coord.city, gsm: @coord.gsm, mail: @coord.mail, office: @coord.office, tel: @coord.tel, zip: @coord.zip }}, use_route: :adherent
      end
  
      assert_redirected_to member_coord_path(assigns(:member))
    end
  
    test "should show coord" do
      get :show, {member_id:@member, id: @coord}, use_route: :adherent
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, {member_id:@member, id: @coord}, use_route: :adherent
      assert_response :success
    end
  
    test "should update coord" do
      put :update, {member_id:@member, id: @coord, coord: { address: @coord.address, city: @coord.city, gsm: @coord.gsm, mail: @coord.mail, office: @coord.office, tel: @coord.tel, zip: @coord.zip }}, use_route: :adherent
      assert_redirected_to coord_path(assigns(:coord))
    end
  
    test "should destroy coord" do
      assert_difference('Coord.count', -1) do
        delete :destroy, {member_id:@member, id: @coord}, use_route: :adherent
      end
  
      assert_redirected_to coords_path
    end
  end
end
