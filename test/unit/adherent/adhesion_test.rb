# coding utf-8

require 'test_helper'

module Adherent
  class AdhesionTest < ActiveSupport::TestCase
    test 'une adhésion valide' do
      @ad = Adhesion.new(from_date:'01/08/2013', to_date:'31/08/2013')
      @ad.member_id = 1
      assert_equal true, @ad.valid?
    end
    
    test 'from_date doit être avant to_date' do
      @ad = Adhesion.new(from_date:'01/09/2013', to_date:'31/08/2013')
      @ad.member_id = 1
      assert_equal false, @ad.valid?
    end
  end
end
