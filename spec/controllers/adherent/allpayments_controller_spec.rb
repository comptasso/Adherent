require 'rails_helper'

module Adherent
  
  
  describe AllpaymentsController, :type => :controller do
  fixtures :all  
    
  before(:each) do
   @routes = Adherent::Engine.routes 
  end
  
    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        expect(response).to be_success 
      end
    end
  
  end
end
