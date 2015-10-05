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
  
  
  describe 'Imputation on adh'  do
    
    # soit un paiement et une adhésion, lorsqu'on impute le paiement
    # sur cette adhésion, il est créé un réglement pour le montant adapté, 
    # soit la totalité de l'adhésion si le non imputé est supérieur
    # soit le montant non imputé si le non imputé est inférieur
    before(:each) do
      @m = create_members(1).first # on créé un member
      @p = create_payment(@m) # un payement de 50€ par défaut
    end
    
    after(:each) do
      Adherent::Adhesion.delete_all
    end
    
    it 'avec un adhésion de 50' do
      @a = Adherent::Adhesion.create!(member_id:@m.id, amount:50,
        from_date:Date.today, to_date:(Date.today.years_since(1)))
      @p.imputation_on_adh(@a.id)
      expect(@p.non_impute).to eq 0
      expect(@a).to be_is_paid
    end
    
    it 'avec un adhésion de 60' do
      @a = Adherent::Adhesion.create!(member_id:@m.id, amount:60,
        from_date:Date.today, to_date:(Date.today.years_since(1)))
      @p.imputation_on_adh(@a.id)
      expect(@p.non_impute).to eq 0
      expect(@a).not_to be_is_paid
      expect(@a.due).to eq 10
    end
    
    it 'avec un adhésion de 60' do
      @a = Adherent::Adhesion.create!(member_id:@m.id, amount:40,
        from_date:Date.today, to_date:(Date.today.years_since(1)))
      @p.imputation_on_adh(@a.id)
      expect(@p.non_impute).to eq 10
      expect(@a).to be_is_paid
      expect(@a.due).to eq 0
    end
    
    
  end
  
  describe 'list_imputations', wip:true do
    
    # la liste des imputations donne un Array d'information sur les 
    # règlements associés à un paiement, array construit avec la méthode
    # member.to_s.
    # La méthode ne doit pas créer d'erreur même si l'adhésion ou le membre
    # n'existe plus
    before(:each) do
      @m = create_members(1).first # on créé un member
      @p = create_payment(@m) # un payement de 50€ par défaut
    end
    
    after(:each) do
      Adherent::Adhesion.delete_all
    end
    
    it 'avec une seule imputation' do
      @a = Adherent::Adhesion.create!(member_id:@m.id, amount:50,
        from_date:Date.today, to_date:(Date.today.years_since(1)))
      @p.imputation_on_adh(@a.id)
      @p.reglements(true)
      expect(@p.list_imputations).to eq [member:@m.to_s, amount:50, r_id:@p.reglements.first.id]
    end
    
    it 'avec deux imputations' do
      @a = Adherent::Adhesion.create!(member_id:@m.id, amount:10,
        from_date:Date.today, to_date:(Date.today.years_since(1)))
      @p.imputation_on_adh(@a.id)
      @a2 = Adherent::Adhesion.create!(member_id:@m.id, amount:10,
        from_date:Date.today, to_date:(Date.today.years_since(1)))
      @p.imputation_on_adh(@a2.id)
      @p.reglements(true)
      expect(@p.list_imputations).
        to eq([{member:@m.to_s, amount:10, r_id:@p.reglements.first.id},
          {member:@m.to_s, amount:10, r_id:@p.reglements.last.id}])
    end
    
    it 'avec un adhérent effacé, affiche Adhésion inconnue' do
       @a = Adherent::Adhesion.create!(member_id:@m.id, amount:50,
        from_date:Date.today, to_date:(Date.today.years_since(1)))
      @p.imputation_on_adh(@a.id)
      @p.reglements(true)
      @a.delete
      expect(@p.list_imputations).
        to eq [{member:'Inconnue', amount:50, r_id:@p.reglements.first.id}]
    end
    
    
    
  end
  
end  