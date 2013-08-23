$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "adherent/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "adherent"
  s.version     = Adherent::VERSION
  s.authors     = ["Jean-Claude Lepage"]
  s.email       = ["jean-claude.lepage@m4x.org"]
  s.homepage    = "http://faiteslescomptes.fr"
  s.license     = 'MIT'
  s.summary     = "Gestion des adhérents d'une association"
  s.description = "Ajoute un modèle et des vues pour créer des adhérents"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.14"
  s.add_dependency "simple_form", "~> 2.1.0"
  s.add_dependency "sass-rails", "~> 3.2.0"
  s.add_dependency "haml-rails"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "simple_form"
  
  
 
  s.add_development_dependency "pg"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
end
