# coding utf-8

require 'rails_helper'


RSpec.configure do |c| 
  #  c.filter = {wip:true}
end

describe 'ADHESIONS', :type => :feature do  
  fixtures :all
  
  before(:each) do
    @member= adherent_members(:Durand)
  end
   
  describe 'création d une adhésion' do
     
    it 'la page new adhesion affiche un form' do
      visit adherent.new_member_adhesion_path @member
      expect(page.find('h3').text).to eq("Renouvellement ou nouvelle adhésion pour #{@member.to_s}")
      expect(page.all('form').size).to eq(1)
    end
     
    it 'remplir le form et cliquer crée une adhésion et renvoie sur la page index' do
      visit adherent.new_member_adhesion_path @member
      fill_in 'Du', with:'01/08/2013'
      fill_in 'Au', with:'31/07/2014'
      fill_in 'Montant', with:'150.25'
      expect {click_button 'Enregistrer'}.to change {@member.adhesions.count}.by(1)
      expect(page.find('h3').text).to eq("Historique des adhésions pour #{@member.to_s}") 
    end
    
    
  end
   
  describe 'la table des adhésions pour un membre' do
    
    before(:each) do
      @member.adhesions.create!(:from_date=>Date.today, :to_date=>Date.today.months_since(1), amount:876.54) 
      visit adherent.member_adhesions_path @member
    end
    
    it 'affiche les adhésions' do
      
      expect(page.find('h3').text).to eq("Historique des adhésions pour #{@member.to_s}")
      expect(page.all('table').size).to eq(1)
    end
    
    describe 'les icones d action' do
      
      it 'edit revoie sur la page de modification' do
        click_link('Modifier')
        expect(page.find('h3').text).to eq("Modification adhésion pour #{@member.to_s}")
      end
      
      it 'money_plus permet d enregistrer un règlement' do
        click_link('Money-plus')
        expect(page.find('h3').text).to eq("Enregistrement d'un paiement de #{@member.to_s}")
      end
      
      
    end
  end
   
   
   
end
