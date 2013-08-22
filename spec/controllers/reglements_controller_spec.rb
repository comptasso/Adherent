# coding utf-8

require 'spec_helper'

describe Adherent::ReglementsController do
  
  before(:each) do
   @routes = Adherent::Engine.routes
   @member = mock_model(Adherent::Member)
   @pay = mock_model(Adherent::Payment, :member=>@member, :non_impute=>52)
  end
  
  describe 'GET new' do
    
    it 'rend la vue new' do
      Adherent::Payment.should_receive(:find).with(@pay.to_param).and_return @pay
      @pay.stub_chain(:reglements, :new).and_return(@reglt = mock_model(Adherent::Reglement))
      get :new, payment_id:@pay.to_param
      assigns[:reglement].should == @reglt
      response.should render_template('new')
    end
    
    it 'preremplit @reglement avec non impute' do
      Adherent::Payment.stub(:find).with(@pay.to_param).and_return @pay
      @pay.should_receive(:reglements).and_return(@ar =double(Arel))
      @ar.should_receive(:new).with(:amount=>52).and_return(@reglt = mock_model(Adherent::Reglement))
      get :new, payment_id:@pay.to_param
    end
    
  end
  
  describe 'POST create' do
    
    it 'renvoie vers la liste des payments' do
      Adherent::Payment.stub(:find).with(@pay.to_param).and_return @pay
      @pay.should_receive(:imputation_on_adh).with('9')
      post :create, {payment_id:@pay.to_param, :reglement=>{:adhesion_id=>'9'}}
      response.should redirect_to member_payments_url(@pay.member)
    end
    
    
  end
  
  
end
