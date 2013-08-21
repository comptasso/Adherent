module Adherent
  class Engine < ::Rails::Engine
    isolate_namespace Adherent
    
    I18n.default_locale = :fr
      
    config.generators.templates.unshift File.expand_path("lib/templates", root)
    
    config.generators do |g|
      g.test_framework :rspec
    #  g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

  end
end
