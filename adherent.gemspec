# -*- encoding: utf-8 -*-

# Maintain your gem's version:
require "adherent/version"

Gem::Specification.new do |s|
  s.name = "adherent"
  s.version = '0.3.10'
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jean-Claude Lepage"]
  s.date = "2015-06-20"
  s.description = "Ajoute un mod\u{e8}le et des vues pour cr\u{e9}er des adh\u{e9}rents"
  s.email = ["jean-claude.lepage@m4x.org"]
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.homepage = "http://faiteslescomptes.fr"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Gestion des adh\u{e9}rents d'une association"
  s.test_files = Dir["spec/**/*"]
  
  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sprockets-rails>, [">= 2.2.4", "~> 2.2"])
      s.add_runtime_dependency(%q<rails>, ["< 4.2", ">= 4.1"])
      s.add_runtime_dependency(%q<simple_form>, ["~> 3.1"])
      s.add_runtime_dependency(%q<bootstrap-sass>, [">= 3.3.4.0", "~> 3.3"])
      s.add_runtime_dependency(%q<sass-rails>, ["~> 4.0"])
      s.add_runtime_dependency(%q<autoprefixer-rails>, ["~> 5.1"])
      s.add_runtime_dependency(%q<coffee-rails>, [">= 4.0.0", "~> 4.0"])
      s.add_runtime_dependency(%q<haml-rails>, ["~> 0.9"])
      s.add_runtime_dependency(%q<jquery-rails>, ["~> 3.1"])
      s.add_runtime_dependency(%q<jquery-ui-rails>, ["~> 5.0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-activemodel-mocks>, ["~> 1.0"])
      s.add_development_dependency(%q<pg>, ["~> 0.17"])
      s.add_development_dependency(%q<capybara>, ["~> 2.4"])
      s.add_development_dependency(%q<selenium-webdriver>, ["~> 2.45"])
      s.add_development_dependency(%q<launchy>, ["~> 2.4"])
      s.add_development_dependency(%q<database_cleaner>, ["~> 1.3"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 4.3"])
      s.add_development_dependency(%q<test-unit>, [">= 3.0.9", "~> 3.0"])
    else
      s.add_dependency(%q<sprockets-rails>, [">= 2.2.4", "~> 2.2"])
      s.add_dependency(%q<rails>, ["< 4.2", ">= 4.1"])
      s.add_dependency(%q<simple_form>, ["~> 3.1"])
      s.add_dependency(%q<bootstrap-sass>, [">= 3.3.4.0", "~> 3.3"])
      s.add_dependency(%q<sass-rails>, ["~> 4.0"])
      s.add_dependency(%q<autoprefixer-rails>, ["~> 5.1"])
      s.add_dependency(%q<coffee-rails>, [">= 4.0.0", "~> 4.0"])
      s.add_dependency(%q<haml-rails>, ["~> 0.9"])
      s.add_dependency(%q<jquery-rails>, ["~> 3.1"])
      s.add_dependency(%q<jquery-ui-rails>, ["~> 5.0"])
      s.add_dependency(%q<rspec-rails>, ["~> 3.0"])
      s.add_dependency(%q<rspec-activemodel-mocks>, ["~> 1.0"])
      s.add_dependency(%q<pg>, ["~> 0.17"])
      s.add_dependency(%q<capybara>, ["~> 2.4"])
      s.add_dependency(%q<selenium-webdriver>, ["~> 2.45"])
      s.add_dependency(%q<launchy>, ["~> 2.4"])
      s.add_dependency(%q<database_cleaner>, ["~> 1.3"])
      s.add_dependency(%q<guard-rspec>, ["~> 4.3"])
      s.add_dependency(%q<test-unit>, [">= 3.0.9", "~> 3.0"])
    end
  else
    s.add_dependency(%q<sprockets-rails>, [">= 2.2.4", "~> 2.2"])
    s.add_dependency(%q<rails>, ["< 4.2", ">= 4.1"])
    s.add_dependency(%q<simple_form>, ["~> 3.1"])
    s.add_dependency(%q<bootstrap-sass>, [">= 3.3.4.0", "~> 3.3"])
    s.add_dependency(%q<sass-rails>, ["~> 4.0"])
    s.add_dependency(%q<autoprefixer-rails>, ["~> 5.1"])
    s.add_dependency(%q<coffee-rails>, [">= 4.0.0", "~> 4.0"])
    s.add_dependency(%q<haml-rails>, ["~> 0.9"])
    s.add_dependency(%q<jquery-rails>, ["~> 3.1"])
    s.add_dependency(%q<jquery-ui-rails>, ["~> 5.0"])
    s.add_dependency(%q<rspec-rails>, ["~> 3.0"])
    s.add_dependency(%q<rspec-activemodel-mocks>, ["~> 1.0"])
    s.add_dependency(%q<pg>, ["~> 0.17"])
    s.add_dependency(%q<capybara>, ["~> 2.4"])
    s.add_dependency(%q<selenium-webdriver>, ["~> 2.45"])
    s.add_dependency(%q<launchy>, ["~> 2.4"])
    s.add_dependency(%q<database_cleaner>, ["~> 1.3"])
    s.add_dependency(%q<guard-rspec>, ["~> 4.3"])
    s.add_dependency(%q<test-unit>, [">= 3.0.9", "~> 3.0"])
  end
end

