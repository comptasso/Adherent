require 'spec_helper'

module Adherent
  describe AllpaymentsController do
    
  before(:each) do
   @routes = Adherent::Engine.routes 
  end
  
    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end
  
  end
end
