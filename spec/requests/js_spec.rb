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
  
  describe 'delete member' do
    it 'supprimer un membre le supprime', js:true do
      create_members
      first_id  = Adherent::Member.first.id
      visit adherent.members_path
      within(:css, 'table tbody tr:first') do
        page.find("#delete_member_#{first_id}").click  
      end
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep 1
      Adherent::Member.count.should == 4
    end
  end
  
  
end

