class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :find_organism
  
  protected
  
  def find_organism
    if session[:organism]
      @organism = Organism.find_by_id(session[:organism])
    else
      flash[:alert] = 'Vous devez d\'abord choisir un organisme'
      redirect_to main_app.organisms_path
    end
  end
end
