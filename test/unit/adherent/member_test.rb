require 'test_helper'

module Adherent
  class MemberTest < ActiveSupport::TestCase
    test 'un membre n est pas valide si son numéro existe déja' do
      @m = adherent_members(:one)
      nm =Member.new(number:@m.number, name:@m.name, forname:@m.forname)
      assert_equal false, nm.valid?
    end
    
    test 'mais l est si le numéro est différent' do
      @m = adherent_members(:one)
      nm =Member.new(number:(@m.number + '1'), name:@m.name, forname:@m.forname)
      assert_equal true, nm.valid?
    end
  end
end
