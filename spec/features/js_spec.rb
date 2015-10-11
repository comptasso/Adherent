# coding utf-8

require 'rails_helper'
require 'database_cleaner' 


RSpec.configure do |config|
  config.use_transactional_fixtures = false
 
  config.before :each do
    if Capybara.current_driver == :rack_test 
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean 
  end
  
  # config.filter = {wip:true}

end

module Adherent

describe 'javascript requests', :type => :feature do
  fixtures :all
  
 
  
  describe 'delete member', js:true do 
    
    it 'supprimer un membre sans payment le supprime'do 
      @member = adherent_members(:Durand)
      @domid = "#member_#{@member.id}" 
      visit adherent.members_path
      within(@domid) do 
         click_link 'Supprimer'   
      end
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      expect(Adherent::Member.count).to eq(2) 
    end
  end
  
  describe 'delete adhesions', js:true do
    
    it 'supprimer une adhésion dans la liste la supprime'  do
      @member = adherent_members(:Dupont)
      nb_adhs = @member.adhesions.count
      adh = @member.adhesions.last
      adh_id = "#adhesion_#{adh.id}"
      visit adherent.member_adhesions_path(@member)
      within(adh_id) do
        click_link 'Supprimer'  
      end
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      expect(@member.adhesions(true).count).to eq(nb_adhs - 1)
    end
    
  end
  
  describe 'delete payment', js:true   do 
    it 'détruit le payment' do
      @member = adherent_members(:Dupont)
      nb_pays = @member.payments.count
      @pay = @member.payments.last
      visit adherent.member_payment_path(@member, @pay)
      click_link 'Supprimer'  
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      expect(@member.payments(true).count).to eq(nb_pays - 1)
    end
  end
   
  
end

end