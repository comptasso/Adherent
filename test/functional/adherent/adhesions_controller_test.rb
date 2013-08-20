require 'test_helper'

module Adherent
  class AdhesionsControllerTest < ActionController::TestCase
    setup do
      @member = adherent_members(:jcl)
      @adhesion = adherent_adhesions(:one)
      @valid_attr = {}
    end
    
    test "should get index" do
      get :index, {member_id:@member.id}, use_route: :adherent
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, {member_id:@member.id, id:@adhesion.to_param}, use_route: :adherent
      assert_response :success
    end
  
    test "should get new" do
      get :new, {member_id:@member.id},  use_route: :adherent
      assert_response :success
    end
  
    test "should get show" do
      get :show,{member_id:@member.id, id:@adhesion.to_param}, use_route: :adherent
      assert_response :success
    end
  
  end
end
