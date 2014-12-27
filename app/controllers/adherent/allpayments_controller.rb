require_dependency "adherent/application_controller"

module Adherent
  class AllpaymentsController < ApplicationController
    def index
      @payments = @organism.payments
    end
  end
end
