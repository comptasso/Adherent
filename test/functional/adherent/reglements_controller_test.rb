require 'test_helper'

module Adherent
  class ReglementsControllerTest < ActionController::TestCase
    setup do
      @payment = adherent_payments(:one)
      @adhestion = adherent_adhesions(:one)
    end
  
    test "should get new" do
      get :new, payment_id:@payment.to_param, use_route: :adherent
      assert_response :success
    end
    
    test "should create" do
      post :create, { payment_id:@payment.to_param,
        :reglement=>{:adhesion_id=>@adhestion.id}}, use_route: :adherent
      
      assert_redirected_to member_payments_path(@payment.member)
    end
  
    
  
  end
end
