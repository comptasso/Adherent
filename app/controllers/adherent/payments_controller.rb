require_dependency "adherent/application_controller"

module Adherent
  class PaymentsController < ApplicationController 
    
    before_filter :find_member
    
    def index
      @payments = @member.payments
    end
    
    def show
      @payment = @member.payments.find_by_id(params[:id])
    end
  
    def new
      @payment = @member.payments.new(date:Date.today, amount:@member.unpaid_amount)
    end
    
    def create
      @payment=@member.payments.new(params[:payment])
      if @payment.save
        
        flash[:notice] = 'Le paiement a été enregistré' 
        redirect_to member_payments_path(@member)
      else
        render 'new'
      end
    end
    
    def edit
      @payment = @member.payments.find_by_id(params[:id])
    end
    
    def update
      @payment = @member.payments.find_by_id(params[:id])
      if @payment.update_attributes(params[:payment])
        
        flash[:notice] = 'Le paiement a été modifié' 
        redirect_to member_payments_path(@member)
      else
        
        flash[:alert] = base_errors_messages(@payment)
        render 'edit'
      end
    end
    
       
    
    # DELETE /payment/1
    # DELETE /coords/1.json
    def destroy
      @payment = @member.payments.find(params[:id])
      if @payment.destroy
        flash[:notice] = 'Le paiement a été supprimé'
      else
        flash[:alert] = base_errors_messages(@payment)
      end
  
      respond_to do |format|
        format.html { redirect_to member_payments_url(@member) }
      end
    end
    
    
    protected
    
    
    
    def find_member
      @member = Member.find(params[:member_id])
    end
    
    # cette méthode permet à l'application qui intègre le gem adhérent 
    # de passer un message d'erreur à ce controller en ajoutant 
    # une erreur sur :base.
    # 
    def base_errors_messages(pay)
      perm = pay.errors.messages[:base]
      Rails.logger.debug "Inspection de perm #{perm.inspect}"
      if perm
        perm.join('<br/>').html_safe
      else
        nil        
      end
    end
  end
end
