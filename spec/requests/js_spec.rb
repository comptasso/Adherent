# coding utf-8

require 'spec_helper'
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
end

describe 'javascript requests' do
  include Fixtures
  
  before(:each) do
    create_members
    @member = @members.first
  end
  
  describe 'delete member' do
    it 'supprimer un membre le supprime', js:true do
      visit adherent.members_path
      within(:css, 'table tbody tr:first') do
        click_link 'Supprimer'   
      end
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      Adherent::Member.count.should == 4
    end
  end
  
  describe 'delete adhesions', js:true do
    
    it 'supprimer une adhésion dans la liste la supprime' do
      @member.next_adhesion.save
      visit adherent.member_adhesions_path(@member)
      within(:css, 'table tbody tr:first') do
        click_link 'Supprimer'  
      end
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      Adherent::Adhesion.count.should == 0
    end
    
  end
  
  describe 'delete payment', js:true do
    it 'détruit le payment' do
      @member.payments.create!(date:Date.today, amount:54.32, mode:'Chèque')
      visit adherent.member_payments_path(@member)
      within(:css, 'table tbody tr:first') do
        click_link 'Supprimer'  
      end
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      Adherent::Payment.count.should == 0
    end
  end
   
  
end

