# coding utf-8

require 'spec_helper'


RSpec.configure do |c|
  #  c.filter = {wip:true}
end

describe 'ADHESIONS' do  
  include Fixtures 
  
  
  before(:each) do
    create_members(1)
    @member= @members.first
  end
   
  after(:each) do
    Adherent::Member.delete_all
  end
   
  describe 'création d une adhésion' do
     
    it 'la page new adhesion affiche un form' do
      visit adherent.new_member_adhesion_path @member
      page.find('h3').text.should == "Renouvellement ou nouvelle adhésion pour #{@member.to_s}"
      page.all('form').should have(1).form
    end
     
    it 'remplir le form et cliquer crée une adhésion et renvoie sur la page index' do
      visit adherent.new_member_adhesion_path @member
      fill_in 'Du', with:'01/08/2013'
      fill_in 'Au', with:'31/07/2014'
      fill_in 'Montant', with:'150.25'
      expect {click_button 'Enregistrer'}.to change {@member.adhesions.count}.by(1)
      page.find('h3').text.should =="Historique des adhésions pour #{@member.to_s}" 
    end
    
    
  end
   
  describe 'la table des adhésions pour un membre' do
    
    before(:each) do
      @member.adhesions.create!(:from_date=>Date.today, :to_date=>Date.today.months_since(1), amount:876.54) 
      visit adherent.member_adhesions_path @member
    end
    
    it 'affiche les adhésions' do
      
      page.find('h3').text.should =="Historique des adhésions pour #{@member.to_s}"
      page.all('table').should have(1).element
    end
    
    describe 'les icones d action' do
      
      it 'edit revoie sur la page de modification' do
        click_link('Modifier')
        page.find('h3').text.should == "Modification adhésion pour #{@member.to_s}"
      end
      
      it 'money_plus permet d enregistrer un règlement' do
        click_link('Money-plus')
        page.find('h3').text.should == "Enregistrement d'un paiement de #{@member.to_s}"
      end
      
      
    end
  end
   
   
   
end
