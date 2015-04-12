# coding utf-8

require 'rails_helper'

RSpec.configure do |c|
 # c.exclusion_filter = {js:true}
 # c.filter = {wip:true}
end


describe Adherent::Member, :type => :model do
  
  def valid_attributes
    {name:'Dupont', forname:'Jules', number:'Adh 001'}
  end
  
  describe 'validation' do
    it 'valid_attributes est valide' do
      m = Adherent::Member.new(valid_attributes)
      m.organism_id = 1
      expect(m).to be_valid
    end
    
    it 'invalide sans nom' do
      va = valid_attributes
      va.delete(:name)
      m = Adherent::Member.new(va)
      m.organism_id = 1
      expect(m).not_to be_valid
    end
    
    it 'invalide sans prenom' do
      va = valid_attributes
      va.delete(:forname)
      m = Adherent::Member.new(va)
      m.organism_id = 1
      expect(m).not_to be_valid
    end
    
    it 'invalide sans numéro' do
      va = valid_attributes
      va.delete(:number)
      m = Adherent::Member.new(va)
      m.organism_id = 1
      expect(m).not_to be_valid
    end
    
    describe 'test de birthdate' do
      before(:each) do
        @m = Adherent::Member.new(valid_attributes)
        @m.organism_id = 1
      end
      
      it 'on peut rentrer une date de naissance' do
        @m.birthdate = '06/06/1944'
        @m.save
        expect(@m.read_attribute(:birthdate)).to eq(Date.civil(1944,6,6))
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
        expect(m).not_to be_valid
      end
      
      it 'mais on peut si organisme différent' do
        m = Adherent::Member.new(name:'Buck', forname:'Charles', number:'Adh 001')
        m.organism_id = 2
        expect(m).to be_valid
      end
      
      
    end
    
  end 
  
  describe 'méthodes' do
    
    before(:each) do
      @m = Adherent::Member.new(valid_attributes)
      @m.organism_id = 1
    end
    
    it 'to s renvoie le nom et le prénom' do
      expect(@m.to_s).to eq('Jules DUPONT')
    end
    
    describe 'next_adhesion' do
      
      it 'next_adhesion renvoie une adhésion relevant de ce membre' do
        expect(@m.next_adhesion).to be_an_instance_of(Adherent::Adhesion)
      end
      
      it 'avec 0 comme montant' do
        expect(@m.next_adhesion.amount).to eq(0)
      end
      
      it 'mais on peut fournir un montant' do
        @na = @m.next_adhesion(25)
        expect(@na.amount).to eq(25)
      end
      
      context 'avec déjà une adhésion' do
        
        before(:each) do
          @m.save!
          @m.next_adhesion(26.66).save!
          
        end
        
        it 'next_adhesion renvoie une adhésion' do
          expect(@m.next_adhesion).to be_an_instance_of(Adherent::Adhesion)
        end
        
        it 'dont le montant est identique au précédent'do
          expect(@m.next_adhesion.amount).to eq(26.66)
        end
        
        it 'mais on peut surcharger' do
          expect(@m.next_adhesion(44).amount).to eq(44)
        end
        
        
      end
    
    end
    
    describe 'les adhésions impayées' do
      
      before(:each) do
        allow(@m).to receive(:adhesions).and_return @ar=double(Arel)
        allow(@ar).to receive(:order).with(:to_date).and_return(@ar)
        allow(@ar).to receive(:unpaid).and_return([double(:due=>12), double(:due=>27)])          
      end
      
      it 'le membre a des adhésions non payées' do
        expect(@m).to be_unpaid_adhesions
      end
      
          
      it 'pour un montant total de 39' do
        expect(@m.unpaid_amount).to eq(39)
      end
      
      
      
    end
    
    describe 'jusquau' do
      
      context 'sans adhésion' do
        
        it 'renvoie inconnu' do
          allow(@m).to receive(:last_adhesion).and_return nil
          allow(@m).to receive(:created_at).and_return Time.now
          expect(@m.jusquau).to eq(I18n::l(Date.today))
        end
        
      end
      
      context 'avec adhésion' do
        it 'renvoie la date de fin cette adhésion' do
          allow(@m).to receive(:last_adhesion).
            and_return double(Adherent::Adhesion, to_date:Date.today)
          expect(@m.jusquau).to eq(Date.today)
        end
        
      end
      
      
      
    end
    
  end
   
end


