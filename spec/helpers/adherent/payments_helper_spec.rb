# coding utf-8

require 'rails_helper'

describe Adherent::PaymentsHelper do
  
  def duo
    "#{I18n::l(Date.today)} au #{I18n::l(Date.today.years_since(1)-1)}"
  end
  
  fixtures :all
  
  context 'le paiement est fait par un membre pour son adhésion' do
    
    before(:each) do
      @pay = adherent_payments(:pay_1)
      @mem = @pay.member
    end
    
    it 'indique l adhésion' do
      expect(recu_cotisation(@pay, @mem)).
        to eq("Adhésion pour la période du #{duo}")
    end
    
    it 'même si le membre n existe plus' do
      @mem.destroy
      expect(recu_cotisation(@pay, @mem)).
        to eq("l'adhésion de Effacé pour la période du ??? au ???")
    end
    
  end
  
  context 'avec un payment qui couvre plusieurs reglements' do
    
    before(:each) do
      @pay = adherent_payments(:pay_2)
      @mem = adherent_members(:Dupont)
    end
    
    it 'sait faire la liste des adhesions concernées' do
      adh1 = @pay.reglements.first.adhesion
      adh2 = @pay.reglements.last.adhesion
      expect(recu_cotisation(@pay, @mem)).
        to eq("les adhésions de <ul><li>#{coords(adh2)} pour la période du #{duo}</li><li>#{coords(adh1)} pour la période du #{duo}</li></ul>")
    end
    
    it 'sans erreur même si le membre n existe plus' do
      @mem.destroy
      expect {recu_cotisation(@pay, @mem)}.
        not_to raise_error
    end
  end
  
  
end