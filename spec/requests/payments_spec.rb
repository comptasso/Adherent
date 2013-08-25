# coding utf-8

require 'spec_helper'


RSpec.configure do |c|
#  c.filter = {wip:true}
end

describe 'PAYMENTS' do
   include Fixtures 
   
   before(:each) do
     create_members(1)
     @member= @members.first
     @member.next_adhesion.save
   end
   
   describe 'création d un payment' do
     
     it 'la page new payment affiche un form' do
       visit adherent.new_member_payment_path @member
       page.find('h3').text.should == "Enregistrement d'un paiement de #{@member.to_s}"
       page.all('form').should have(1).form
     end
     
     it 'remplir le form et cliquer crée un payement et renvoie sur la page des adhésions' do
       visit adherent.new_member_payment_path(@member)
       fill_in 'Date', with:'01/08/2013'
       fill_in 'Montant', with:150.25
       select 'CB'
       expect {click_button 'Enregistrer'}.to change {@member.payments.count}.by(1)
       page.find('h3').text.should =="Historique des paiements reçus de #{@member.to_s}" 
     end
    
    
   end
   
  describe 'la table des payments pour un membre' do
    
    before(:each) do
      @member.payments.create!(:date=>Date.today, :mode=>'CB', amount:876.54) 
      visit adherent.member_payments_path @member
    end
    
    it 'affiche les paiements' do
      
      page.find('h3').text.should =="Historique des paiements reçus de #{@member.to_s}"
      page.all('table').should have(1).element
    end
    
    describe 'les icones d action' do
      
      it 'cliquer sur imputation conduit à la vue new_règlement' do
        
        click_link 'Imputation'
        page.find('h3').text.should == "Imputation du montant restant (876.54) payé par #{@member.to_s}"  
        
      end
      
      
    end
  end
   
   
   
end
