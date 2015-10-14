# coding utf-8

require 'rails_helper'
 

RSpec.configure do |c| 
  # c.filter = {:wip=>true}
end

describe 'Payment', :type => :model do 
  fixtures :all 
  
  describe 'validations' do 
    
    before(:each) do 
      @pay = adherent_payments(:pay_1) 
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
      p = Adherent::Payment.new(date:Date.today, amount:-5, mode:'CB', member_id:1)
      expect(p).to be_valid
    end
    
    it 'un payment a un mode qui ne peut être que CB, Chèque,...' do
      @pay.mode = 'autre moyen de payement'
      expect(@pay).not_to be_valid
    end
  end
  
  describe 'imputation after create' do
    
    before(:each) do 
      @member = adherent_members(:Fidele)
    end
    
    it 'enregistrer un payement crée 1 règlement' do
      expect{@member.payments.create(:amount=>54, date:Date.today, mode:'CB')}.
        to change {Adherent::Reglement.count}.by 2 # car Fidele a 2 adhesions
    end
    
    it 'sait calculer le montant restant à imputer si plus que suffisant' do
      mdu = @member.unpaid_amount
      pay = @member.payments.create(:amount=>54, date:Date.today, mode:'CB')
      expect(pay.non_impute).to eq(54 - mdu)  
    end
    
    it 'un paiement hors date ajoute une erreur' do
      p = @member.payments.create(:amount=>25, date:Date.today << 5, mode:'CB')
      expect(p.errors.messages[:date]).to eq(['hors limite'])
    end
    
    it 'et n\'est pas sauvé' do
      p = @member.payments.new(:amount=>25, date:Date.today << 5, mode:'CB')
      expect {p.save}.not_to change {Adherent::Payment.count}
    end
    
  end
  
  describe 'Imputation on adh'  do
    
    # soit un paiement et une adhésion, lorsqu'on impute le paiement
    # sur cette adhésion, il est créé un réglement pour le montant adapté, 
    # soit la totalité de l'adhésion si le non imputé est supérieur
    # soit le montant non imputé si le non imputé est inférieur
    before(:each) do
      @p = adherent_payments(:pay_1) # un paiement de 15 €
      @m = @p.member # le membre Dupont
      @a = @m.adhesions.first # avec une adhésion de 26.66
      @mdu = @m.unpaid_amount
    end
    
    it 'avec un paiement du montant dù' do
      p = @m.payments.create!(amount:@mdu, mode:'CB', date:Date.today)
      expect(p.non_impute).to eq 0
      expect(@a).to be_is_paid
    end
    
    it 'avec un paiement inférieur à l adhésion'  do
      p = @m.payments.create!(amount:@mdu -1, mode:'CB', date:Date.today)
      expect(p.non_impute).to eq 0
      expect(@a).not_to be_is_paid
      expect(@a.due).to eq(1)
    end
    
    it 'avec un paiement supérieur à l adhésion' do
      p = @m.payments.create!(amount:(@mdu + 3), mode:'CB', date:Date.today)
      expect(p.non_impute).to eq 3
      expect(@a).to be_is_paid
      expect(@a.due).to eq 0
    end
    
  end
  
end  