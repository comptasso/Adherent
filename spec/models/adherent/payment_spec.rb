# coding utf-8

require 'spec_helper'

RSpec.configure do |c| 
  # c.filter = {:wip=>true}
end

describe 'Payment' do
  include Fixtures
  
  def new_payment  
    @pay = Adherent::Payment.new(amount:111, mode:'CB', date:Date.today)
    @pay.member_id = 1
    @pay.stub_chain(:member, :organism).and_return(Organism.new)
    @pay
  end
 
  describe 'validations' do 
    
    before(:each) do
      new_payment
    end
    
    it 'new_payment est valide' , wip:true do
      @pay.should be_valid 
    end
    
    it 'un payment appartient à un membre' do
      @pay.member_id = nil
      @pay.should_not be_valid
    end
    
    it 'un payment a une date' do
      @pay.date = nil
      @pay.should_not be_valid
    end
    
    it 'un payment a un montant' do
      @pay.amount = nil
      @pay.should_not be_valid
    end
    
    it 'le montant peut être négatif' do
      @pay.amount = -5
      @pay.should be_valid
    end
    
    it 'un payment a un mode qui ne peut être que CB, Chèque,...' do
      @pay.mode = 'autre moyen de payement'
      @pay.should_not be_valid
    end
  end
  
  describe 'imputation after create' do
    
    before(:each) do 
      create_members(1)
      @member = @members.first
      @member.adhesions.create(:from_date=>Date.today, :to_date=>Date.today.months_since(1), amount:27 )
      @member.next_adhesion.save
      @member.stub(:organism).and_return(Organism.new)
    end
    
    it 'enregistrer un payement crée 2 règlements' do
      @member.payments.create(:amount=>54, date:Date.today, mode:'CB')
      Adherent::Reglement.count.should == 2
    end
    
    it 'ne crée qu un règlement si le montant est insuffisant' do
      @member.payments.create(:amount=>25, date:Date.today, mode:'CB')
      Adherent::Reglement.count.should == 1
    end
    
    it 'sait calculer le montant restant à imputer si plus que suffisant' do
      pay = @member.payments.create(:amount=>60, date:Date.today, mode:'CB')
      pay.non_impute.should == 6
    end
    
    it 'un paiement hors date ajoute une erreur' do
      p = @member.payments.new(:amount=>25, date:Date.today << 5, mode:'CB')
      p.save 
      p.errors.messages[:date].should == ['hors limite']
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
      Adherent::Adhesion.should_receive(:find).with(1).and_return(@adh = double(Adherent::Adhesion))
      @adh.should_receive(:add_reglement).with(@pay.id, @pay.amount)
      @pay.imputation_on_adh(1)
    end
    
    
  end
  
end  