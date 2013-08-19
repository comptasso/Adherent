require 'test_helper'

module Adherent
  class PaymentsControllerTest < ActionController::TestCase
    
    setup do
      @member = adherent_members(:jcl)
      @payment =adherent_payments(:one)
    end
    
    test "should get index" do
      get :index, member_id:@member.to_param, use_route: :adherent
      assert_response :success
    end
  
    test "should get new" do
      get :new, member_id:@member.to_param, use_route: :adherent
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, {member_id:@member.to_param, id:@payment.to_param}, use_route: :adherent
      assert_response :success
    end
  
    test "should get show" do
      get :show, {member_id:@member.to_param, id:@payment.to_param}, use_route: :adherent
      assert_response :success
    end
  
  end
end
