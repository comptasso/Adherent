# coding utf-8

require 'spec_helper'

RSpec.configure do |c|
 # c.exclusion_filter = {js:true}
 # c.filter = {wip:true}
end

describe 'Member' do
  
  def valid_attributes
    {name:'Dupont', forname:'Jules', number:'Adh 001'}
  end
  
  describe 'validation' do
    it 'valid_attributes est valide' do
      m = Adherent::Member.new(valid_attributes)
      m.organism_id = 1
      m.should be_valid
    end
    
    it 'invalide sans nom' do
      va = valid_attributes
      va.delete(:name)
      m = Adherent::Member.new(va)
      m.organism_id = 1
      m.should_not be_valid
    end
    
    it 'invalide sans prenom' do
      va = valid_attributes
      va.delete(:forname)
      m = Adherent::Member.new(va)
      m.organism_id = 1
      m.should_not be_valid
    end
    
    it 'invalide sans numéro' do
      va = valid_attributes
      va.delete(:number)
      m = Adherent::Member.new(va)
      m.organism_id = 1
      m.should_not be_valid
    end
    
    describe 'test de birthdate' do
      before(:each) do
        @m = Adherent::Member.new(valid_attributes)
        @m.organism_id = 1
      end
      
      it 'on peut rentrer une date de naissance' do
        @m.birthdate = '06/06/1944'
        @m.save
        @m.read_attribute(:birthdate).should == Date.civil(1944,6,6)
      end
      
      
    end
    
    describe 'le numéro est unique' do
      before(:each) do
        @m = Adherent::Member.new(valid_attributes)
        @m.organism_id = 1
        @m.save!
      end
      
      it 'on ne peut créer un autre adhérent avec la même référence' do
        m = Adherent::Member.new(name:'Buck', forname:'Charles', number:'Adh 001')
        m.organism_id = 1
        m.should_not be_valid
      end
      
      it 'mais on peut si organisme différent' do
        m = Adherent::Member.new(name:'Buck', forname:'Charles', number:'Adh 001')
        m.organism_id = 2
        m.should be_valid
      end
      
      
    end
    
  end 
  
  describe 'méthodes' do
    
    before(:each) do
      @m = Adherent::Member.new(valid_attributes)
      @m.organism_id = 1
    end
    
    it 'to s renvoie le nom et le prénom' do
      @m.to_s.should == 'Jules DUPONT'
    end
    
    describe 'next_adhesion' do
      
      it 'next_adhesion renvoie une adhésion relevant de ce membre' do
        @m.next_adhesion.should be_an_instance_of(Adherent::Adhesion)
      end
      
      it 'avec 0 comme montant' do
        @m.next_adhesion.amount.should == 0
      end
      
      it 'mais on peut fournir un montant' do
        @na = @m.next_adhesion(25)
        @na.amount.should == 25
      end
      
      context 'avec déjà une adhésion' do
        
        before(:each) do
          @m.save!
          @m.next_adhesion(26.66).save!
          
        end
        
        it 'next_adhesion renvoie une adhésion' do
          @m.next_adhesion.should be_an_instance_of(Adherent::Adhesion)
        end
        
        it 'dont le montant est identique au précédent'do
          @m.next_adhesion.amount.should == 26.66
        end
        
        it 'mais on peut surcharger' do
          @m.next_adhesion(44).amount.should == 44
        end
        
        
      end
    
    end
    
    describe 'les adhésions impayées' do
      
      before(:each) do
        @m.stub(:adhesions).and_return @ar=double(Arel)
        @ar.stub(:order).with(:to_date).and_return(@ar)
        @ar.stub(:unpaid).and_return([double(:due=>12), double(:due=>27)])          
      end
      
      it 'le membre a des adhésions non payées' do
        @m.should be_unpaid_adhesions
      end
      
          
      it 'pour un montant total de 39' do
        @m.unpaid_amount.should == 39
      end
      
      
      
    end
    
  end
   
end
