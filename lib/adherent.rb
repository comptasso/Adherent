require "adherent/engine"

module Adherent
  class Engine < Rails::Engine
    
    
   
    def paths
      p = super
      p.add "lib/templates", :glob=>"*"
      p
    end
    
    
    
    
  end
end
