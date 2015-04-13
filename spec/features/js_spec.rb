# coding utf-8

require 'rails_helper'
require 'database_cleaner'
require 'support/fixtures'

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
  include Fixtures
  
  before(:each) do
    create_members
    @member = @members.first
    @domid = "#member_#{@member.id}"
  end
  
  describe 'delete member' , wip:true do
    it 'supprimer un membre le supprime', js:true do
      visit adherent.members_path
      within(@domid) do 
         click_link 'Supprimer'   
      end
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      expect(Adherent::Member.count).to eq(4)
    end
  end
  
  describe 'delete adhesions', js:true do
    
    it 'supprimer une adhésion dans la liste la supprime' do
      adh = @member.next_adhesion.save
      adh = @member.adhesions.last
      adh_id = "#adhesion_#{adh.id}"
      visit adherent.member_adhesions_path(@member)
      within(adh_id) do
        click_link 'Supprimer'  
      end
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      expect(Adherent::Adhesion.count).to eq(0)
    end
    
  end
  
  describe 'delete payment', js:true do 
    it 'détruit le payment' do
      @pay = @member.payments.create!(date:Date.today, amount:54.32, mode:'Chèque')
      visit adherent.member_payment_path(@member, @pay)
      click_link 'Supprimer'  
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      expect(Adherent::Payment.count).to eq(0)
    end
  end
   
  
end

end