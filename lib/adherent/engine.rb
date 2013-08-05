module Adherent
  class Engine < ::Rails::Engine
    isolate_namespace Adherent
    
    I18n.default_locale = :fr
      
    config.generators.templates.unshift File.expand_path("lib/templates", root)

  end
end
