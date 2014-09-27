# coding utf-8

require 'spec_helper'


RSpec.configure do |c|
#  c.filter = {wip:true}
end

describe 'PAYMENTS', :type => :feature do
   include Fixtures 
   
   before(:each) do
     create_members(1) 
     @member= @members.first
     @member.next_adhesion.save 
   end
   
   describe 'création d un payment' do
     
     it 'la page new payment affiche un form' do
       visit adherent.new_member_payment_path @member
       expect(page.find('h3').text).to eq("Enregistrement d'un paiement de #{@member.to_s}")
       expect(page.all('form').size).to eq(1) 
     end
     
     it 'remplir le form et cliquer crée un payement et renvoie sur la page des adhésions' do
       visit adherent.new_member_payment_path(@member)
       fill_in 'Date', with: I18n.l(Date.today)
       fill_in 'Montant', with:150.25
       select 'CB'
       expect {click_button 'Enregistrer'}.to change {@member.payments.count}.by(1)
       expect(page.find('h3').text).to eq("Historique des paiements reçus de #{@member.to_s}") 
     end
    
    
   end
   
  describe 'la table des payments pour un membre' do
    
    before(:each) do
      
      @member.payments.create!(:date=>Date.today, :mode=>'CB', amount:876.54) 
      
      visit adherent.member_payments_path @member
    end
    
    it 'affiche les paiements' do
      
      expect(page.find('h3').text).to eq("Historique des paiements reçus de #{@member.to_s}")
      expect(page.all('table').size).to eq(1) 
    end
    
    describe 'les icones d action' do
      
      it 'cliquer sur imputation conduit à la vue new_règlement' do
        
        click_link 'Imputation'
        expect(page.find('h3').text).to eq("Imputation du montant restant (876.54) payé par #{@member.to_s}")  
        
      end
      
      
    end
  end
  
  describe 'le formulaire pour un nouveau paiement' do
    
    before(:each) do
      visit adherent.new_member_payment_path @member
    end
    
    it 'affiche le titre' do
      expect(page.find('h3').text).to eq("Enregistrement d'un paiement de #{@member.to_s}")
    end
    
    it 'le montant doit être en format anglais' do
      expect(page.find('input#payment_amount').value).to eq('0.00')
    end
    
  end
   
   
   
end
