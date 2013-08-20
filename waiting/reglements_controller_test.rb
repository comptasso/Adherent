require 'test_helper'

module Adherent
  class ReglementsControllerTest < ActionController::TestCase
    setup do
      @payment = adherent_payments(:one)
    end
  
    test "should get new" do
      puts '\n'
      puts @payment.inspect
      puts @payment.member.inspect
      puts "non impute : #{@payment.non_impute}"
      puts "Adhesion impayées : #{Adhesion.unpaid}"
      get :new, payment_id:@payment.to_param, use_route: :adherent
      assert_response :success
    end
  
    
  
  end
end
