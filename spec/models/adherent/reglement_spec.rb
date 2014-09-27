# coding utf-8

require 'rails_helper'

describe 'Règlement', :type => :model do
  include Fixtures
  
  describe 'validations' do
    
    before(:each) do 
      @reglement = Adherent::Reglement.new(amount:50)
      @reglement.payment_id = 1
      @reglement.adhesion_id = 9
    end
    
    it 'est valide' do
      expect(@reglement).to be_valid
    end
    
    it 'mais pas sans payment_id' do
      @reglement.payment_id = nil
      expect(@reglement).not_to be_valid
    end
    
    it 'ni pas sans adhesion_id' do
      @reglement.adhesion_id = nil
      expect(@reglement).not_to be_valid
    end
    
    it 'ni sans montant' do
      @reglement.amount = nil
      expect(@reglement).not_to be_valid
    end
    
    it 'qui doit être positif' do
      @reglement.amount = -5.55
      expect(@reglement).not_to be_valid
    end
    
  end
  
end
  
