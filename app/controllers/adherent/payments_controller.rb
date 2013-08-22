require_dependency "adherent/application_controller"

module Adherent
  class PaymentsController < ApplicationController
    
    before_filter :find_member
    
    def index
      @payments = @member.payments
    end
  
    def new
      @payment = @member.payments.new(date:Date.today, amount:@member.unpaid_amount)
    end
    
    def create
      @payment=@member.payments.new(params[:payment])
      if @payment.save
        
        flash[:notice] = 'Le paiement a été enregistré' 
        redirect_to member_adhesions_path(@member)
      else
        flash[:alert] = 'Impossible d\'enregistrer ce paiement'
        render 'new'
      end
    end
    
    def update
      @payment = @member.payments.find(params[:id])
      if @payment.update_attributes(params[:payment])
        flash[:notice] = 'Le paiement a été mis à jour'
        redirect_to member_payment_url(@member, @payment)
      else
        flash[:alert] = 'Impossible de modifier ce paiement'
        render 'edit'
       end
     end
  
    def edit
      @payment = @member.payments.find(params[:id])
    end
  
    def show
      @payment = @member.payments.find(params[:id])
    end
    
    # DELETE /payment/1
    # DELETE /coords/1.json
    def destroy
      @payment = @member.payments.find(params[:id])
      @payment.destroy
  
      respond_to do |format|
        format.html { redirect_to member_payments_url(@member) }
        
      end
    end
    
    
    protected
    
    
    
    def find_member
      @member = Member.find(params[:member_id])
    end
  end
end
