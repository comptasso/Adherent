# coding utf-8

require 'spec_helper'

describe 'Règlement' do
  include Instances
  
  describe 'validations' do
    
    before(:each) do
      @reglement = Adherent::Reglement.new(amount:50)
      @reglement.payment_id = 1
      @reglement.adhesion_id = 9
    end
    
    it 'est valide' do
      @reglement.should be_valid
    end
    
    it 'mais pas sans payment_id' do
      @reglement.payment_id = nil
      @reglement.should_not be_valid
    end
    
    it 'ni pas sans adhesion_id' do
      @reglement.adhesion_id = nil
      @reglement.should_not be_valid
    end
    
    it 'ni sans montant' do
      @reglement.amount = nil
      @reglement.should_not be_valid
    end
    
    it 'qui doit être positif' do
      @reglement.amount = -5.55
      @reglement.should_not be_valid
    end
    
  end
  
end
  