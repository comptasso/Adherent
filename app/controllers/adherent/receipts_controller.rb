# coding utf-8

require_dependency "adherent/application_controller"

module Adherent
  class ReceiptsController < ApplicationController
     
    # GET /receipts/1
    def show
      @payment = Payment.find_by_id(params[:payment_id])
      unless @payment
        flash[:alert] = 'Le règlement demandé n\'a pas été trouvé'
        redirect_to payments_url and return
      end 
      @member = @payment.member
      # affichage de receipts#show
      render action: "show", layout:false
    end
    
    
    
  end
end