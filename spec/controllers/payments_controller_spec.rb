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
  
  describe "GET show" do
    it 'appelle le payement' do
      @member.should_receive(:payments).and_return(@ar = double(Arel)) 
      @ar.should_receive(:find).with('1').and_return(@pay = mock_model(Adherent::Payment))
      get :show, {member_id:@member.to_param, id:'1'}
    end
    
    it 'assigne le payment et rend la vue' do
      @member.stub_chain(:payments, :find).and_return(@pay = mock_model(Adherent::Payment))
      get :show, {member_id:@member.to_param, id:'1'}
      assigns[:payment].should == @pay
      response.should render_template('show')
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
  
  describe "GET edit" do
    it 'appelle le payement' do
     @member.should_receive(:payments).and_return(@ar = double(Arel)) 
      @ar.should_receive(:find).with('1').and_return(@pay = mock_model(Adherent::Payment))
      get :edit, {member_id:@member.to_param, id:'1'}
    end
    
    it 'assigne le payment et rend la vue' do
      @member.stub_chain(:payments, :find).and_return(@pay = mock_model(Adherent::Payment))
      get :edit, {member_id:@member.to_param, id:'1'}
      assigns[:payment].should == @pay
      response.should render_template('edit')
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
      response.should redirect_to(member_adhesions_url(assigns[:member]))
    end
    
    it 'et vers la vue new autrement' do
      @member.stub_chain(:payments, :new).and_return(@pay = mock_model(Adherent::Payment))
      @pay.stub(:save).and_return false
      post :create, {member_id:@member.to_param, :payment=>@attrib}
      response.should render_template('new')
    end
    
       
  end
  
  describe "POST update" do
    
    before(:each) do
      @pay = mock_model(Adherent::Payment)
      
    end
    
    it 'trouve le payment et appelle update_attributes' do
      @member.should_receive(:payments).and_return(@ar = double(Arel)) 
      @ar.should_receive(:find).with('1').and_return @pay
      @pay.should_receive(:update_attributes).with({'mode'=>'Chèque'}).and_return true
      post :update, {member_id:@member.to_param, id:'1', :payment=>{:mode=>'Chèque'} }
    end
    
    it 'redirige vers show en cas de succès' do
      @member.stub_chain(:payments, :find).and_return @pay
      @pay.stub(:update_attributes).with({'mode'=>'Chèque'}).and_return true
      post :update, {member_id:@member.to_param, id:'1', :payment=>{:mode=>'Chèque'} }
      response.should redirect_to(member_payment_url(assigns[:member], assigns[:payment]))
    end
    
    it 'et vers la vue edit autrement' do
      @member.stub_chain(:payments, :find).and_return @pay
      @pay.stub(:update_attributes).with({'mode'=>'Chèque'}).and_return false
      post :update, {member_id:@member.to_param, id:'1', :payment=>{:mode=>'Chèque'} }
      response.should render_template 'edit'
    end
    
    it 'la variable @payment est assignée' do
      @member.stub_chain(:payments, :find).and_return @pay
      @pay.stub(:update_attributes).with({'mode'=>'Chèque'}).and_return false
      post :update, {member_id:@member.to_param, id:'1', :payment=>{:mode=>'Chèque'} }
      assigns[:payment].should == @pay
    end
  end

 
  
  
end

