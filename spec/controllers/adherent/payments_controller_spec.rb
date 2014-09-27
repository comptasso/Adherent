# coding utf-8

require 'rails_helper'

describe Adherent::PaymentsController, :type => :controller do
  
  before(:each) do
    @routes = Adherent::Engine.routes
    @member = mock_model(Adherent::Member)
    allow(Adherent::Member).to receive(:find).with(@member.to_param).and_return @member
    allow(@controller).to receive(:guess_date).and_return Date.today
  end
    
  
  describe "GET index" do
    
    it 'rend la vue index' do
      allow(@member).to receive(:payments)
      get :index, member_id:@member.to_param
      expect(response).to render_template("index")
    end
    

    it "assigns all coords as @coords" do
      expect(@member).to receive(:payments).and_return [1,2]
      get :index, member_id:@member.to_param
      expect(assigns(:payments)).to eq([1,2])
  
    end
  end
  
  
  
  describe 'GET new' do 
    
    it 'assigne un payments et rend la vue new' do
      
      expect(@member).to receive(:payments).and_return(@ar = double(Arel))
      expect(@member).to receive(:unpaid_amount).and_return 57
      expect(@ar).to receive(:new).with(date:Date.today, amount:57).and_return(@pay = mock_model(Adherent::Payment))
      get :new, member_id:@member.to_param
      expect(assigns[:payment]).to eq(@pay)
      expect(response).to render_template('new') 
    end
    
  end
  
  
  describe "POST create" do
    
    before(:each) do
      @attrib = {'amount'=>'57', 'mode'=>'CB', 'date'=>I18n.l(Date.today) }
    end
    
    it 'crée une nouvelle adhésion avec les params' do
      expect(@member).to receive(:payments).and_return(@ar = double(Arel)) 
      expect(@ar).to receive(:new).with(@attrib).and_return(@pay = mock_model(Adherent::Payment))
      expect(@pay).to receive(:save).and_return true
      post :create, {member_id:@member.to_param, :payment=>@attrib}
      
    end
    
    it 'renvoie vers la vue des adhésions' do
      @member.stub_chain(:payments, :new).and_return(@pay = mock_model(Adherent::Payment))
      allow(@pay).to receive(:save).and_return true
      post :create, {member_id:@member.to_param, :payment=>@attrib}
      expect(response).to redirect_to(member_payments_url(assigns[:member]))
    end
    
    it 'et vers la vue new autrement' do
      @member.stub_chain(:payments, :new).and_return(@pay = mock_model(Adherent::Payment))
      allow(@pay).to receive(:save).and_return false
      post :create, {member_id:@member.to_param, :payment=>@attrib}
      expect(response).to render_template('new')
    end
    
       
  end
  
  describe "GET show" do  
    
    it 'rend la vue show' do
      @pay = mock_model(Adherent::Payment)
      expect(@member).to receive(:payments).and_return(@ar = double(Arel))
      expect(@ar).to receive(:find_by_id).with(@pay.to_param).and_return @pay
      get :show, member_id:@member.to_param , id:@pay.to_param
      expect(assigns[:payment]).to eq(@pay)
      expect(response).to render_template('show') 
    end
  end

 
  
  
end

