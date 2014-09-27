# coding utf-8

require 'spec_helper'


RSpec.configure do |c|
#  c.filter = {wip:true}
end

describe 'afficher tous les membres', :type => :feature do
   include Fixtures 
  
  
   before(:each) do
     create_members
   end
  
  it 'affiche la liste' do
    visit adherent.members_path
    expect(page).to have_selector('h3', text:'Liste des membres')
  end
  
  it 'affiche le tableau des membres' do
    visit adherent.members_path
    expect(page.all('table > tbody > tr').size).to eq(5)
  end
  
  describe 'vérification des liens' do
    
    before(:each) do 
      visit adherent.members_path
    end
    
    it 'cliquer sur le lien détail mène à la vue new coordonnées' do
      first_id  = Adherent::Member.first.id
      within(:css, 'table tbody tr:first') do
        page.find("#coord_member_#{first_id}").click  
      end
      expect(page.find('h3')).to have_content 'Saisie des coordonnées de le prénom NOM_0' 
      
    end
    
    it 'si le membre a des coordonnées le détail les affiche' do
      first = Adherent::Member.first
      first.create_coord(city:'Marseille')
      within(:css, 'table tbody tr:first') do
        page.find("#coord_member_#{first.id}").click  
      end
      expect(page.find('h3')).to have_content 'Fiche coordonnées le prénom NOM_0' 
    end
    
    it 'adhesion renvoie vers nouvelle adhésion' do
      first_id  = Adherent::Member.first.id
      within(:css, 'table tbody tr:first') do
        page.find("#adhesion_member_#{first_id}").click  
      end
      expect(page.find('h3')).to have_content 'Renouvellement ou nouvelle adhésion pour le prénom NOM_0' 
    end
    
    it 'ou vers la liste des adhésions' do
      first = Adherent::Member.first
      first.next_adhesion.save
      within(:css, 'table tbody tr:first') do
        page.find("#adhesion_member_#{first.id}").click  
      end
      expect(page.find('h3')).to have_content 'Historique des adhésions pour le prénom NOM_0' 
    end
    
    it 'payement renvoie vers la vue index des payment' do
      first_id  = Adherent::Member.first.id
      within(:css, 'table tbody tr:first') do
        page.find("#payment_member_#{first_id}").click  
      end
      expect(page.find('h3')).to have_content 'Historique des paiements reçus de le prénom NOM_0'
      
    end
    
    it 'payement renvoie vers la vue index des payment' do
      first_id  = Adherent::Member.first.id
      within(:css, 'table tbody tr:first') do
        page.find("#edit_member_#{first_id}").click  
      end
      expect(page.find('h3')).to have_content 'Modification membre'
      
    end
    
    it 'l icone nouveau renvoie sur le form new' do
      click_on('Nouveau')
      expect(page.find('h3').text).to eq('Nouveau membre')
      
    end
     
  end
  
  describe 'create_members', wip:true do
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