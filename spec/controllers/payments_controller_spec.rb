# coding utf-8

require 'spec_helper'

describe Adherent::PaymentsController do
  
  before(:each) do
   @routes = Adherent::Engine.routes
   @member = mock_model(Adherent::Member)
   Adherent::Member.stub(:find).with(@member.to_param).and_return @member
  end
    
  
  describe "GET index" do
    
    it 'rend la vue index' do
      @member.stub(:payments)
      get :index, member_id:@member.to_param
      response.should render_template("index")
    end
    

    it "assigns all coords as @coords" do
      @member.should_receive(:payments).and_return [1,2]
      get :index, member_id:@member.to_param
      assigns(:payments).should == [1,2]
  
    end
  end
  
  
  
  describe 'GET new' do
    
    it 'assigne un payments et rend la vue new' do
      @member.should_receive(:payments).and_return(@ar = double(Arel))
      @member.should_receive(:unpaid_amount).and_return 57
      @ar.should_receive(:new).with(date:Date.today, amount:57).and_return(@pay = mock_model(Adherent::Payment))
      get :new, member_id:@member.to_param
      assigns[:payment].should == @pay
      response.should render_template('new')
    end
    
  end
  
  
  describe "POST create" do
    
    before(:each) do
      @attrib = {'amount'=>'57', 'mode'=>'CB', 'date'=>I18n.l(Date.today) }
    end
    
    it 'crée une nouvelle adhésion avec les params' do
      @member.should_receive(:payments).and_return(@ar = double(Arel)) 
      @ar.should_receive(:new).with(@attrib).and_return(@pay = mock_model(Adherent::Payment))
      @pay.should_receive(:save).and_return true
      post :create, {member_id:@member.to_param, :payment=>@attrib}
      
    end
    
    it 'renvoie vers la vue des adhésions' do
      @member.stub_chain(:payments, :new).and_return(@pay = mock_model(Adherent::Payment))
      @pay.stub(:save).and_return true
      post :create, {member_id:@member.to_param, :payment=>@attrib}
      response.should redirect_to(member_payments_url(assigns[:member]))
    end
    
    it 'et vers la vue new autrement' do
      @member.stub_chain(:payments, :new).and_return(@pay = mock_model(Adherent::Payment))
      @pay.stub(:save).and_return false
      post :create, {member_id:@member.to_param, :payment=>@attrib}
      response.should render_template('new')
    end
    
       
  end
  
  

 
  
  
end

