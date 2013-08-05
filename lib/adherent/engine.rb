module Adherent
  class Engine < ::Rails::Engine
    isolate_namespace Adherent
    
  config.app_generators do |g|
    g.templates.unshift File::expand_path('../templates', __FILE__)
  end

  end
end
