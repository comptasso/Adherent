# coding utf-8

require 'rails_helper'
require 'support/fixtures'

RSpec.configure do |c| 
  # c.filter = {:wip=>true}
end

describe 'Payment', :type => :model do 
  include Fixtures
  
  def new_payment  
    @pay = Adherent::Payment.new(amount:111, mode:'CB', date:Date.today)
    @pay.member_id = 1
    allow(@pay).to receive(:member).and_return(@ar = double(Arel))
    allow(@ar).to receive(:organism).and_return(Organism.new)
    @pay
  end
 
  describe 'validations' do 
    
    before(:each) do
      new_payment
    end
    
    it 'new_payment est valide' , wip:true do
      expect(@pay).to be_valid 
    end
    
    it 'un payment appartient à un membre' do
      @pay.member_id = nil
      expect(@pay).not_to be_valid
    end
    
    it 'un payment a une date' do
      @pay.date = nil
      expect(@pay).not_to be_valid
    end
    
    it 'un payment a un montant' do
      @pay.amount = nil
      expect(@pay).not_to be_valid
    end
    
    it 'le montant peut être négatif' do
      @pay.amount = -5
      expect(@pay).to be_valid
    end
    
    it 'un payment a un mode qui ne peut être que CB, Chèque,...' do
      @pay.mode = 'autre moyen de payement'
      expect(@pay).not_to be_valid
    end
  end
  
  describe 'imputation after create' do
    
    before(:each) do 
      create_members(1)
      @member = @members.first
      @member.adhesions.create(:from_date=>Date.today, :to_date=>Date.today.months_since(1), amount:27 )
      @member.next_adhesion.save
      allow(@member).to receive(:organism).and_return(Organism.new)
    end
    
    it 'enregistrer un payement crée 2 règlements' do
      @member.payments.create(:amount=>54, date:Date.today, mode:'CB')
      expect(Adherent::Reglement.count).to eq(2)
    end
    
    it 'ne crée qu un règlement si le montant est insuffisant' do
      @member.payments.create(:amount=>25, date:Date.today, mode:'CB')
      expect(Adherent::Reglement.count).to eq(1)
    end
    
    it 'sait calculer le montant restant à imputer si plus que suffisant' do
      pay = @member.payments.create(:amount=>60, date:Date.today, mode:'CB')
      expect(pay.non_impute).to eq(6)
    end
    
    it 'un paiement hors date ajoute une erreur' do
      p = @member.payments.new(:amount=>25, date:Date.today << 5, mode:'CB')
      p.save 
      expect(p.errors.messages[:date]).to eq(['hors limite'])
    end
    
    it 'et n\'est pas sauvé' do
      p = @member.payments.new(:amount=>25, date:Date.today << 5, mode:'CB')
      expect {p.save}.not_to change {Adherent::Payment.count}
      
    end
    
    
  end
  
  describe 'imputation on adh' do
    
    before(:each) do
      new_payment
    end
    
    it 'on peut imputer un montant sur une adhesion quelconque' do
      expect(Adherent::Adhesion).to receive(:find).with(1).and_return(@adh = double(Adherent::Adhesion))
      expect(@adh).to receive(:add_reglement).with(@pay.id, @pay.amount)
      @pay.imputation_on_adh(1)
    end
    
    
  end
  
end  