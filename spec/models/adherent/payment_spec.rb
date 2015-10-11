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
      @member = adherent_members(:Fidele)
    end
    
    it 'enregistrer un payement crée 1 règlement' do
      expect{@member.payments.create(:amount=>54, date:Date.today, mode:'CB')}.
        to change {Adherent::Reglement.count}.by 2 # car Fidele a 2 adhesions
    end
    
    it 'sait calculer le montant restant à imputer si plus que suffisant' do
      pay = @member.payments.create(:amount=>54, date:Date.today, mode:'CB')
      expect(pay.non_impute).to eq(4)
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
  
  
  describe 'Imputation on adh' do
    
    # soit un paiement et une adhésion, lorsqu'on impute le paiement
    # sur cette adhésion, il est créé un réglement pour le montant adapté, 
    # soit la totalité de l'adhésion si le non imputé est supérieur
    # soit le montant non imputé si le non imputé est inférieur
    before(:each) do
      @p = adherent_payments(:pay_1) # un paiement de 15 €
      @m = @p.member # le membre Dupont
      @a = @m.adhesions.first # avec une adhésion de 26.66
    end
    
    it 'avec un paiement du montant de l adhésion' do
      @p.amount = 26.66; @p.save
      @p.imputation_on_adh(@a.id)
      expect(@p.non_impute).to eq 0
      expect(@a).to be_is_paid
    end
    
    it 'avec un paiement inférieur à l adhésion'  do
      @p.imputation_on_adh(@a.id)
      expect(@p.non_impute).to eq 0
      expect(@a).not_to be_is_paid
      expect(@a.due).to eq 11.66
    end
    
    it 'avec un paiement supérieur à l adhésion' do
      @p.amount = 36.66; @p.save
      @p.imputation_on_adh(@a.id)
      expect(@p.non_impute).to eq 10
      expect(@a).to be_is_paid
      expect(@a.due).to eq 0
    end
    
    
  end
  
  describe 'list_imputations'  do
    
    # la liste des imputations donne un Array d'information sur les 
    # règlements associés à un paiement, array construit avec la méthode
    # member.to_s.
    # La méthode ne doit pas créer d'erreur même si l'adhésion ou le membre
    # n'existe plus
    before(:each) do
      @p = adherent_payments(:pay_1) # un paiement de 15 €
      @m = @p.member # le membre Dupont
      @a = @m.adhesions.first # avec une adhésion de 26.66
    end
    
    it 'avec une seule imputation' do
      @p.imputation_on_adh(@a.id)
      @p.reglements(true)
      expect(@p.list_imputations).to eq [member:@m.to_s, amount:15, r_id:@p.reglements.first.id]
    end
    
    it 'avec deux imputations' do
      @a.update_attribute(:amount, 10)
      @p.imputation_on_adh(@a.id)
      @a2 = @m.adhesions.create!(amount:10,
        from_date:Date.today, to_date:(Date.today.years_since(1)))
      @p.imputation_on_adh(@a2.id)
      @p.reglements(true)
      expect(@p.list_imputations).
        to eq([{member:@m.to_s, amount:10, r_id:@p.reglements.first.id},
          {member:@m.to_s, amount:5, r_id:@p.reglements.last.id}])
    end
    
    it 'avec un adhérent effacé, affiche Adhésion inconnue' do
      @p.imputation_on_adh(@a.id)
      @p.reglements(true)
      @a.delete
      expect(@p.list_imputations).
        to eq [{member:'Inconnue', amount:15, r_id:@p.reglements.first.id}]
    end
    
    
    
  end
  
end  