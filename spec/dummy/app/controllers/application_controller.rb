class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :find_organism
  
  protected
  
  def find_organism
     @organism = Organism.find_by_id(session[:organism])
  end
end
