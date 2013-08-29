require_dependency "adherent/application_controller"

module Adherent
  class ReglementsController < ApplicationController
    
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
    
    # TODO voir pour faire les deux approches (succès et échec)
    def create
      @payment = Payment.find(params[:payment_id])
      @payment.imputation_on_adh(params[:reglement][:adhesion_id])
      redirect_to member_payments_path(@payment.member)
      
    end
    
    def show
      @payment = Payment.find(params[:payment_id])
      @reglement = @payment.reglements.find(params[:id])
    end
    
    
    
   # DELETE /reglement/1
    
    def destroy
      @payment = Payment.find(params[:payment_id])
      @reglement = @payment.reglements.find(params[:id])
      if @reglement.destroy
        flash[:notice] = 'Le reglement a été supprimé'
      else
        flash[:alert] = 'Le règlement n\'a pas pu être supprimé'
      end
  
      respond_to do |format|
        format.html { redirect_to member_payment_url(@payment.member, @payment) }
      end
    end
    
  
    
  end
end
