# coding utf-8

require 'rails_helper'


RSpec.configure do |c|
#  c.filter = {wip:true}
end

describe 'afficher tous les membres', :type => :feature do
  fixtures :all
  
  it 'affiche la liste' do
    visit adherent.members_path
    expect(page).to have_selector('h3', text:'Liste des membres')
  end
  
  it 'affiche le tableau des membres'  do
    visit adherent.members_path
    expect(page.all('table > tbody > tr').size).to eq(Adherent::Member.count)
  end
  
  describe 'vérification des liens' do
    
    before(:each) do 
      visit adherent.members_path
      @m = Adherent::Member.first
    end
    
    it 'sans coordonnées, renvoie vers la saisie des coordonnées' do
      page.find("#coord_member_#{@m.id}").click   
      expect(page.find('h3')).to have_content "Saisie des coordonnées de #{@m.to_s}"
      
    end
    
    it 'avec, les affiche'  do 
      m = adherent_members(:Dupont)
      page.find("#coord_member_#{m.id}").click  
      expect(page.find('h3')).to have_content "Saisie des coordonnées de #{m.to_s}"
    end
    
    it 'adhesion renvoie vers nouvelle adhésion'   do
      m = adherent_members(:Durand)
      page.find("#adhesion_member_#{m.id}").click  
      expect(page.find('h3')).to have_content "Renouvellement ou nouvelle adhésion pour #{m.to_s}"
    end
    
    it 'ou vers la liste des adhésions' do
      m = adherent_members(:Dupont)
      page.find("#adhesion_member_#{m.id}").click  
      expect(page.find('h3')).to have_content "Historique des adhésions pour #{m.to_s}" 
    end
    
    it 'payement renvoie vers la vue index des payment' do
      m = adherent_members(:Dupont)
      page.find("#payment_member_#{m.id}").click  
      expect(page.find('h3')).to have_content "Historique des paiements reçus de #{m.to_s}"
      
    end
    
    it 'on peut éditer le membre' do  
      page.find("#edit_member_#{@m.id}").click  
      expect(page.find('h3')).to have_content 'Modification membre'
      
    end
    
    it 'l icone nouveau renvoie sur le form new' do
      click_on('Nouveau')
      expect(page.find('h3').text).to eq('Nouveau membre')
      
    end
     
  end
  
  describe 'create_members'  do
    it 'remplir le form crée un membre et renvoie sur la page new_coord' do
      visit adherent.new_member_path
      fill_in 'Nom', with:'James'
      fill_in 'Numéro d\'adh.', with:'ADH1'
      fill_in 'Prénom', with:'Jessie'
      expect {click_button 'Créer le membre'}.to change {Adherent::Member.count}.by(1)
      expect(page.find('h3').text).to eq('Saisie des coordonnées de Jessie JAMES')
    end
     
    
  end
  
  
end