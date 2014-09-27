require 'rails_helper'
require 'support/fixtures'


RSpec.configure do |c|
#  c.filter = {wip:true}
end

describe 'COORDONNEE', :type => :feature do
   include Fixtures 
  
  
   before(:each) do
     create_members(1)
     @member = @members.first
   end
   
   describe 'création de coordonnées' do
     it 'la page a un titre et un form' do
       visit adherent.new_member_coord_path @member
       expect(page.find('h3').text).to eq("Saisie des coordonnées de #{@member.to_s}")
     end
     
     it 'remplir le form crée la fiche coordonnées' do
       visit adherent.new_member_coord_path @member
       fill_in 'E-mail', with:'joe.dalton@penitencier.us'
       fill_in 'Ville', with:'Oklahoma city'
       expect {click_button 'Enregistrer'}.to change {Adherent::Coord.count}.by(1)
      end
      
     it 'la fiche est bien rattachée au membre' do
       visit adherent.new_member_coord_path @member
       fill_in 'E-mail', with:'joe.dalton@penitencier.us'
       fill_in 'Ville', with:'Oklahoma city'
       click_button 'Enregistrer'
       expect(@member.coord.city).to eq('Oklahoma city')
       expect(@member.coord.mail).to eq('joe.dalton@penitencier.us')
     end
     
    it 'renvoie sur le page new_adhesion' do
      visit adherent.new_member_coord_path @member
       fill_in 'E-mail', with:'joe.dalton@penitencier.us'
       click_button 'Enregistrer'
       expect(page.find('h3').text).to eq("Renouvellement ou nouvelle adhésion pour #{@member.to_s}")
    end
   end
   
end
  
