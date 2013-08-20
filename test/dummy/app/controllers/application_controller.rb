class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :find_organism
  
  protected
  
  def find_organism
     @organism = Organism.new(title:'Mon association', status:'Association')
  end
end
