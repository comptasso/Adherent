# coding utf-8

require 'test_helper'

module Adherent
  class AdhesionTest < ActiveSupport::TestCase
    test 'une adhésion valide' do
      @ad = Adhesion.new(from_date:'01/08/2013', to_date:'31/08/2013', amount:10.25)
      @ad.member_id = 1
      assert_equal true, @ad.valid?
    end
    
    test 'from_date doit être avant to_date' do
      @ad = Adhesion.new(from_date:'01/09/2013', to_date:'31/08/2013')
      @ad.member_id = 1
      assert_equal false, @ad.valid?
    end
    
    test 'next_adhesion preremplit les champs' do
      @m = adherent_members(:jul)
      na = @m.next_adhesion
      assert_equal I18n::l(Date.today), na.from_date
    end
    
    test 'si une adhésion existe, next_adhesion preremplit avec la dernière adhésion' do
      @m = adherent_members(:jul)
      next_adh = @m.next_adhesion
      @m.next_adhesion.save!
      first_adh = @m.adhesions(true).first
      na = @m.next_adhesion
      assert_equal na.from_date, I18n.l(first_adh.read_attribute(:to_date)+1)
    end
    
    
  end
end
