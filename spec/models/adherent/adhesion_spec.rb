# coding utf-8

require 'rails_helper'


RSpec.configure do |c|
  # c.filter = {wip:true}
end

describe 'Adhesion', :type => :model do
  
  
  fixtures :all
  
  
  before(:each) do
     @adh = adherent_adhesions(:adh_1)
  end
  
  describe 'validations' do
  
    it 'l adhésion est valide ' do
      expect(@adh).to be_valid
    end
  
    it 'mais pas sans membre' do
      @adh.member_id = nil
      @adh.valid?
      expect(@adh.errors[:member_id].size).to eq(1)
    end
  
    it 'ni sans from_date' do
      @adh.from_date = nil
      @adh.valid?
      expect(@adh.errors[:from_date].size).to eq(1)
    end
  
    it 'ni sans to date' do
      @adh.to_date = nil
      @adh.valid?
      expect(@adh.errors[:to_date].size).to eq(1)
    end
  
    it 'ni sans amount' do
      @adh.amount = nil
      @adh.valid?
      expect(@adh.errors[:amount].size).to be > 0
    end
    
    it 'l ordre des dates est respecté' do
      @adh.from_date = Date.today
      @adh.to_date = Date.yesterday
      @adh.valid?
      expect(@adh.errors[:from_date].size).to eq(1)
    end
  
  end
  
  describe 'pick_dater' do
    
    it 'la date est restituée sous forme lisible' do
      expect(@adh.from_date).to be_an_instance_of String
      expect(@adh.from_date).to eq(I18n::l(Date.today))
    end
    
    it 'on peut accéder à la date par read_attribute' do
      expect(@adh.read_attribute(:from_date)).to be_an_instance_of Date
      expect(@adh.read_attribute(:from_date)).to eq(Date.today)
    end
    
    it 'on peut changer la date avec une string bien formatée' do
      @adh.from_date = '06/06/1955'
      expect(@adh.read_attribute(:from_date)).to eq(Date.civil(1955,6,6))
    end
    
    it 'et aussi avec une date' do
      @adh.from_date = Date.civil(1993,8,13)
      expect(@adh.from_date).to eq('13/08/1993')
    end
    
    
  end
  
  describe 'méthodes relatives au payment' do
    
    it 'received fait le total des règlements reçus' do
      expect(@adh).to receive(:reglements).and_return(@ar = double(Arel))
      expect(@ar).to receive(:sum).with(:amount).and_return 564
      expect(@adh.received).to eq(564)
    end
    
    it 'due est la différence entre amount et received' do
      allow(@adh).to receive(:received).and_return 19
      expect(@adh.due).to eq(7.66)
    end
    
    it 'is_paid indique si due vaut zero' do
      allow(@adh).to receive(:due).and_return 0.0
      expect(@adh).to be_is_paid
      
    end
    
    it 'is_paid est faux si due est different de zero' do
      allow(@adh).to receive(:due).and_return 1.0
      expect(@adh).not_to be_is_paid
    end
    
  end
  
  # on utilise des modèles réels car on veut tester la requête proprement dite
  describe 'Ahesion.unpaid' do
    
    before(:each) do
      @m3 = adherent_members(:Fidele)
      @nb_unpaid = Adherent::Adhesion.unpaid.to_a.size
    end
    
    it 'sait calculer le montant total du'  do
      expect(Adherent::Adhesion.unpaid.to_a.sum(&:amount)).to eq(76.66)
    end
        
    it 'un paiement suffisant pour une adhésion règle une adhésion' do
       @m3.payments.create!(date:Date.today, amount:40, mode:'CB')
       expect(Adherent::Adhesion.unpaid.to_a.size).to eq(@nb_unpaid - 1)
       expect(Adherent::Adhesion.unpaid.to_a.sum(&:amount)).to eq(52.66) # celle de 24
    end
     
  end
  
  describe 'next adh values' do
    
    context 'sans adhésion utilise la méthode de classe' do
     
    it 'renvoie une adhesion avec des valeurs par défaut' do
      val = Adherent::Adhesion.next_adh_values
      expect(val).to be_an_instance_of Hash
      expect(val[:from_date]).to eq(I18n::l(Date.today))
      expect(val[:to_date]).to eq(I18n::l(Date.today.years_since(1)-1))
      expect(val[:amount]).to eq(0)
    end
    
      it 'mais on peut surcharger le montant' do
        val = Adherent::Adhesion.next_adh_values(548)
        expect(val[:amount]).to eq(548)
      end
    
    end
    
    context 'quand une adhésion est fournie' do
      
      it 'renvoie une adhésion avec la date de debut égale à la date de fin la précédente plus un jour' do
        val = @adh.next_adh_values
        expect(val[:from_date]).to eq(I18n::l(@adh.read_attribute(:to_date) +1))
        expect(val[:to_date]).to eq(I18n::l(@adh.read_attribute(:to_date).years_since(1)))
      end
      
      it 'le montant est identique au précédent' do
        val = @adh.next_adh_values
        expect(val[:amount]).to eq(@adh.amount)
      end
      
      it 'mais on peut le surcharger' do
        val = @adh.next_adh_values(99.99)
        expect(val[:amount]).to eq(99.99)
      end
      
      
    end
     
  end
  
  describe 'add_reglement' do
    
    it 'le montant imputé est plafonné' do
      @adh.add_reglement(1, 50)
      expect(@adh).to be_is_paid
    end
    
    it 'le montant imputé est celui du payment' do
      du = @adh.due
      @adh.add_reglement(1, 10)
      expect(@adh).not_to be_is_paid
      expect(@adh.due).to eq(du -10)
    end
    
    it 'add_reglement renvoie un règlement' do
      expect(@adh.add_reglement(1, 10)).to be_an_instance_of(Adherent::Reglement)
    end
    
  end
  
end