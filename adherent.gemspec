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
 
  s.add_dependency 'sprockets-rails', '>= 2.1.4'
  s.add_dependency 'rails', '>= 4.0', '< 4.1' 
  s.add_dependency 'simple_form', '~> 3.1'
  # s.add_dependency 'sass', '>= 3.2.10', '< 3.3'
  
  s.add_dependency 'bootstrap-sass', '~> 3.3.1'
  s.add_dependency 'sass-rails', '~> 4.0'
  s.add_dependency 'autoprefixer-rails'
  
  
  s.add_dependency "haml-rails"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  
  s.add_development_dependency "rspec-rails", ">= 3.0"
  s.add_development_dependency "rspec-activemodel-mocks"
  s.add_development_dependency "pg"
  s.add_development_dependency "capybara"
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency "launchy"
  s.add_development_dependency "database_cleaner"
  
   s.test_files = Dir["spec/**/*"]
end
