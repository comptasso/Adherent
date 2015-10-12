require_dependency "adherent/application_controller"

module Adherent
  
  # les routes vers payments sont traitées par ce controller quand elles ne sont
  # pas dépendantes d'un membre. 
  # Si elles sont dépendantes d'un membre, alors, le controller est 
  # PaymentsController. Voir le fichier routes.rb
  
  class AllpaymentsController < ApplicationController
    def index
      @payments = @organism.payments.includes(:member, [:reglements=>[:adhesion=>:member]])
    end
  end
end
