# coding utf-8

require 'spec_helper'

RSpec.configure do |c|
  # c.filter = {wip:true}
end

describe 'Adhesion' do
  include Fixtures 
  
  
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
      @adh.valid?
      @adh.errors[:member_id].size.should == 1
    end
  
    it 'ni sans from_date' do
      @adh.from_date = nil
      @adh.valid?
      @adh.errors[:from_date].size.should == 1
    end
  
    it 'ni sans to date' do
      @adh.to_date = nil
      @adh.valid?
      @adh.errors[:to_date].size.should == 1
    end
  
    it 'ni sans amount' do
      @adh.amount = nil
      @adh.valid?
      @adh.errors[:amount].size.should > 0
    end
    
    it 'l ordre des dates est respecté' do
      @adh.from_date = Date.today
      @adh.to_date = Date.yesterday
      @adh.valid?
      @adh.errors[:from_date].size.should == 1
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
  
  # on utilise des modèles réels car on veut tester la requête proprement dite
  describe 'Ahesion.unpaid' , wip:true do
    
    
    before(:each) do
      create_members(2)
      @m1 = @members.first; @m2 = @members.last
     @a1 =  @m1.adhesions.create!(amount:100, from_date:'01/08/2013', to_date:'31/08/2013')
     @a2 =  @m2.adhesions.create!(amount:50, from_date:'01/08/2013', to_date:'31/08/2013')
     @m2.payments.create!(date:Date.today, amount:40, mode:'CB')
      
    end
    
    after(:each) do
      Adherent::Member.delete_all
    end
    
    it 'requete renvoyant les adhesions impayées' do
       Adherent::Adhesion.unpaid.all.size.should == 2
       Adherent::Adhesion.unpaid.first.reglements_amount.to_i.should == 0
       Adherent::Adhesion.unpaid.last.reglements_amount.to_i.should == 40
    end
    
    it 'on rajoute un payment' do
      @m1.payments.create!(date:Date.today, amount:100, mode:'CB')
      Adherent::Adhesion.unpaid.to_a.size.should == 1
      Adherent::Adhesion.unpaid.first.should == @a2
      Adherent::Adhesion.unpaid.first.reglements_amount.to_i.should == 40
    end
    
    it 'on paye la dernière' do
      @m2.payments.create!(date:Date.today, amount:10, mode:'CB')
      @m1.payments.create!(date:Date.today, amount:100, mode:'CB')
      Adherent::Adhesion.unpaid.to_a.size.should == 0
    end
    
    
  end
  
  describe 'next adh values' do
    
    context 'sans adhésion utilise la méthode de classe' do
     
    it 'renvoie une adhesion avec des valeurs par défaut' do
      val = Adherent::Adhesion.next_adh_values
      val.should be_an_instance_of Hash
      val[:from_date].should == I18n::l(Date.today)
      val[:to_date].should == I18n::l(Date.today.years_since(1)-1)
      val[:amount].should == 0
    end
    
      it 'mais on peut surcharger le montant' do
        val = Adherent::Adhesion.next_adh_values(548)
        val[:amount].should == 548
      end
    
    end
    
    context 'quand une adhésion est fournie' do
      
      it 'renvoie une adhésion avec la date de debut égale à la date de fin la précédente plus un jour' do
        val = @adh.next_adh_values
        val[:from_date].should == I18n::l(@adh.read_attribute(:to_date) +1)
        val[:to_date].should == I18n::l(@adh.read_attribute(:to_date).years_since(1))
      end
      
      it 'le montant est identique au précédent' do
        val = @adh.next_adh_values
        val[:amount].should == @adh.amount
      end
      
      it 'mais on peut le surcharger' do
        val = @adh.next_adh_values(99.99)
        val[:amount].should == 99.99
      end
      
      
    end
     
  end
  
  describe 'add_reglement' do
    
    before(:each) {@adh.save!}
    
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