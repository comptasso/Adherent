require_dependency "adherent/application_controller"

module Adherent
  class ReglementsController < ApplicationController
    def index
    end
  
    # enegistrer un nouveau réglement est en fait créer une nouvelle imputation 
    # pour un paiement. 
    # Il est donc obligatoire d'avoir un paiement
    #
    def new
      
      @payment = Payment.find(params[:payment_id])
      @member = @payment.member
      @reglement = @payment.reglements.new(amount:@payment.non_impute)
      @unpaid_adhesions = Adhesion.unpaid
    end
  
    def show
    end
  end
end
