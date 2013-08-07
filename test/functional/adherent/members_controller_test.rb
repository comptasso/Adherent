require 'test_helper'

module Adherent
  class MembersControllerTest < ActionController::TestCase
    setup do
      @member = adherent_members(:one)
    end
  
    test "should get index" do
      get :index, use_route: :adherent
      assert_response :success
      assert_not_nil assigns(:members)
    end
  
    test "should get new" do
      get :new, use_route: :adherent
      assert_response :success
    end
  
    test "should create member" do
      assert_difference('Member.count') do
        post :create, member: { birthdate: @member.birthdate, forname: @member.forname, name: @member.name, number: @member.number },
           use_route: :adherent
      end
  
      assert_redirected_to new_member_coord_path(assigns(:member))
    end
  
    test "should show member" do
      get :show, id: @member, use_route: :adherent
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, id: @member, use_route: :adherent
      assert_response :success
    end
  
    test "should update member" do
      put :update, id: @member, 
        member: { birthdate: @member.birthdate, forname: @member.forname, name: @member.name, number: @member.number },
        use_route: :adherent
      assert_redirected_to member_path(assigns(:member), )
    end
  
    test "should destroy member" do
      assert_difference('Member.count', -1) do
        delete :destroy, id: @member, use_route: :adherent
      end
  
      assert_redirected_to members_path
    end
  end
end
