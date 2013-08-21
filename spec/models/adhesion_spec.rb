# coding utf-8

require 'spec_helper'

describe 'Adhesion' do
  include Instances
  
  
  before(:each) do
    
    
    
    @adh = Adherent::Adhesion.new(:from_date=>Date.today,
      :to_date=>(Date.today.years_since(1)-1),
      :amount=>19.27)
    @adh.member_id = 1
  end
  
  describe 'validations' do
  
    it 'l adhésion est valide ' do
      @adh.should be_valid
    end
  
    it 'mais pas sans membre' do
      @adh.member_id = nil
      @adh.should have(1).error_on(:member_id)
    end
  
    it 'ni sans from_date' do
      @adh.from_date = nil
      @adh.should have(1).error_on(:from_date)
    end
  
    it 'ni sans to date' do
      @adh.to_date = nil
      @adh.should have(1).error_on(:to_date)
    end
  
    it 'ni sans amount' do
      @adh.amount = nil
      @adh.should have(2).error_on(:amount)
    end
    
    it 'l ordre des dates est respecté' do
      @adh.from_date = Date.today
      @adh.to_date = Date.yesterday
      @adh.should have(1).error_on(:from_date)
    end
  
  end
  
  describe 'pick_dater' do
    
    it 'la date est restituée sous forme lisible' do
      @adh.from_date.should be_an_instance_of String
      @adh.from_date.should == I18n::l(Date.today)
    end
    
    it 'on peut accéder à la date par read_attribute' do
      @adh.read_attribute(:from_date).should be_an_instance_of Date
      @adh.read_attribute(:from_date).should == Date.today
    end
    
    it 'on peut changer la date avec une string bien formatée' do
      @adh.from_date = '06/06/1955'
      @adh.read_attribute(:from_date).should == Date.civil(1955,6,6)
    end
    
    it 'et aussi avec une date' do
      @adh.from_date = Date.civil(1993,8,13)
      @adh.from_date.should == '13/08/1993'
    end
    
    
  end
  
  describe 'méthodes relatives au payment' do
    
    it 'received fait le total des règlements reçus' do
      @adh.should_receive(:reglements).and_return(@ar = double(Arel))
      @ar.should_receive(:sum).with(:amount).and_return 564
      @adh.received.should == 564
    end
    
    it 'due est la différence entre amount et received' do
      @adh.stub(:received).and_return 19
      @adh.due.should == 0.27
    end
    
    it 'is_paid indique si due vaut zero' do
      @adh.stub(:due).and_return 0.0
      @adh.should be_is_paid
      
    end
    
    it 'is_paid est faux si due est different de zero' do
      @adh.stub(:due).and_return 1.0
      @adh.should_not be_is_paid
    end
    
  end
  
  describe 'Ahesion.unpaid' do
    
    it 'renvoie un array avec toutes les adhesions impayées' do
      Adherent::Adhesion.should_receive(:all).and_return([
        mock_model(Adherent::Adhesion, 'is_paid?'=>false),
        mock_model(Adherent::Adhesion, 'is_paid?'=>false),
        mock_model(Adherent::Adhesion, 'is_paid?'=>true),
        ])
      aau  = Adherent::Adhesion.unpaid
      aau.should be_an_instance_of(Array)
      aau.should have(2).elements
      
    end
    
    
  end
  
  describe 'next adhesion' do
    
    it 'renvoie une adhesion avec des valeurs par défaut' do
      val = Adherent::Adhesion.next_adh_values
      val.should be_an_instance_of Hash
      val[:from_date].should == I18n::l(Date.today)
      val[:to_date].should == I18n::l(Date.today.years_since(1)-1)
      val[:amount].should == 0
    end
    
    context 'quand une adhésion est fournie' do
      
      it 'renvoie une adhésion avec la date de debut égale à la date de fin la précédente plus un jour' do
        val = Adherent::Adhesion.next_adh_values(@adh)
        val[:from_date].should == I18n::l(@adh.read_attribute(:to_date) +1)
        val[:to_date].should == I18n::l(@adh.read_attribute(:to_date).years_since(1))
      end
      
      it 'le montant est identique au précédent' do
        val = Adherent::Adhesion.next_adh_values(@adh)
        val[:amount].should == @adh.amount
      end
      
      
    end
     
  end
  
  describe 'add_reglement' do
    
    it 'le montant imputé est plafonné' do
      @adh.add_reglement(1, 50)
      @adh.should be_is_paid
    end
    
    it 'le montant imputé est celui du payment' do
      @adh.add_reglement(1, 10)
      @adh.should_not be_is_paid
      @adh.due.should == 9.27
    end
    
    it 'add_reglement renvoie un règlement' do
      @adh.add_reglement(1, 10).should be_an_instance_of(Adherent::Reglement)
    end
    
  end
  
end