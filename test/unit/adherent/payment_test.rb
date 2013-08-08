# coding utf-8

require 'test_helper'

module Adherent
  class PaymentTest < ActiveSupport::TestCase
    test 'le fixture :one doit être valid' do
      @ap = adherent_payments(:one)
      assert_equal true, @ap.valid?
    end
    
    test 'le fixture :two n est pas valide car montant négatif' do
      @ap = adherent_payments(:two)
      assert_equal false, @ap.valid?
    end
    
    test 'le fixture invalid_mode n est pas valide' do
      @ap = adherent_payments(:invalid_mode)
      assert_equal false, @ap.valid?
    end
    
    
  end
end
