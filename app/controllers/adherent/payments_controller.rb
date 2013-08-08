require_dependency "adherent/application_controller"

module Adherent
  class PaymentsController < ApplicationController
    
    before_filter :find_member
    
    def index
      @payments = @member.payments
    end
  
    def new
      @payment = @member.payments.new
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
