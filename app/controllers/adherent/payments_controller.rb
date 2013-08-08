require_dependency "adherent/application_controller"

module Adherent
  class PaymentsController < ApplicationController
    
    before_filter :find_member
    
    def index
      @payments = @member.payments
    end
  
    def new
      @payment = @member.payments.new(date:Date.today, amount:@member.unpaied_amount)
    end
    
    def create
      @payment=@member.payments.new(params[:payment])
      if @payment.save
        @member.unpaied_adhesions.each {|adh| adh.update_attribute(:payment_id, @payment.id)}
        flash[:notice] = 'le paiement a été enregistré' 
        redirect_to member_adhesions_path(@member)
      else
        flash[:alert] = 'Impossible d\'enregistrer ce paiement'
        render 'new'
      end
    end
  
    def edit
    end
  
    def show
    end
    
    
    protected
    
    def find_member
      @member = Member.find(params[:member_id])
    end
  end
end
