# coding utf-8

require 'rails_helper'

describe Adherent::ReglementsController, :type => :controller do
  
  before(:each) do
   @routes = Adherent::Engine.routes
   @member = mock_model(Adherent::Member)
   @pay = mock_model(Adherent::Payment, :member=>@member, :non_impute=>52)
  end
  
  describe 'GET new' do
    
    it 'rend la vue new' do
      expect(Adherent::Payment).to receive(:find).with(@pay.to_param).and_return @pay
      @pay.stub_chain(:reglements, :new).and_return(@reglt = mock_model(Adherent::Reglement))
      get :new, payment_id:@pay.to_param
      expect(assigns[:reglement]).to eq(@reglt)
      expect(response).to render_template('new')
    end
    
    it 'preremplit @reglement avec non impute' do
      allow(Adherent::Payment).to receive(:find).with(@pay.to_param).and_return @pay
      expect(@pay).to receive(:reglements).and_return(@ar =double(Arel))
      expect(@ar).to receive(:new).with(:amount=>52).and_return(@reglt = mock_model(Adherent::Reglement))
      get :new, payment_id:@pay.to_param
    end
    
  end
  
  describe 'POST create' do
    
    it 'renvoie vers la liste des payments' do
      allow(Adherent::Payment).to receive(:find).with(@pay.to_param).and_return @pay
      expect(@pay).to receive(:imputation_on_adh).with('9')
      post :create, {payment_id:@pay.to_param, :reglement=>{:adhesion_id=>'9'}}
      expect(response).to redirect_to member_payments_url(@pay.member)
    end
    
    
  end
  
  
end
