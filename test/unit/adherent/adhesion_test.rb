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
    
    test 'next_adhesion preremplit les champs' do
      @m = adherent_members(:one)
      na = @m.next_adhesion
      assert_equal na.from_date, I18n.l(Date.today)
    end
    
    test 'si une adhésion existe, next_adhesion preremplit avec la dernière adhésion' do
      @m = adherent_members(:one)
      @m.next_adhesion.save
      first_add = @m.adhesions(true).first
      na = @m.next_adhesion
      assert_equal na.from_date, I18n.l(first_add.read_attribute(:to_date)+1)
    end
    
    
  end
end
