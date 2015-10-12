# coding utf-8

require 'rails_helper'

describe 'PAYMENTS', :type => :feature do
   fixtures :all
   
   before(:each) do
     @member= adherent_members(:Dupont)
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
      visit adherent.member_payments_path @member
    end
    
    it 'affiche une table des paiements' do
      expect(page.find('h3').text).to eq("Historique des paiements reçus de #{@member.to_s}") 
      expect(page.all('table').size).to eq(1) 
    end
    
    describe 'les icones d action' do
      
      it 'cliquer sur imputation conduit à la vue new_règlement' do 
        click_link 'Imputation'
        expect(page.find('h3').text).to eq("Imputation du montant restant (15,00 €) payé par #{@member.to_s}")  
      end
      
    end
  end
  
  describe 'le formulaire pour un nouveau paiement'do
    
    before(:each) do
      visit adherent.new_member_payment_path @member
    end
    
    it 'affiche le titre' do
      expect(page.find('h3').text).to eq("Enregistrement d'un paiement de #{@member.to_s}")
    end
    
    it 'le montant doit être en format anglais' do
      
      expect(page.find('input#payment_amount').value).to eq(@member.unpaid_amount.to_s)
    end
    
  end
  
  describe 'l affichage d un paiement'  do
    before(:each) do
      @payment = adherent_payments(:pay_1)
      visit adherent.member_payment_path @member, @payment
    end
    
    it 'affiche le titre' do
      expect(page.find('h3').text).to eq("Détail d'un paiement")
    end
    
    it 'avec les référence du paiement' do
      expect(page.find('.inner-champ').text).to have_content('Effectué par :')
      expect(page.find('.inner-champ').text).to have_content(@member.name.upcase) 
      
    end
    
    it 'comprend une partie reçu pour impression' do
      expect(page.find('.print').text).to have_content('Le trésorier') 
    end
  end
  
end
