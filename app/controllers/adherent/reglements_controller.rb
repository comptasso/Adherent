require_dependency "adherent/application_controller"

module Adherent
  class ReglementsController < ApplicationController
    def index
      @payment = Payment.find(params[:payment_id])
      @reglements = @payment.reglements
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
    
    def create
      @payment = Payment.find(params[:payment_id])
      @payment.imputation_on_adh(params[:reglement][:adhesion_id])
      redirect_to member_payments_path(@payment.member)
      
    end
  
    def show
    end
  end
end
