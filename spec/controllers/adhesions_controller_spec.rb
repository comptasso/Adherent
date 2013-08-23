# coding utf-8

require 'spec_helper'

describe Adherent::AdhesionsController do
  
  before(:each) do
   @routes = Adherent::Engine.routes
   @member = mock_model(Adherent::Member)
   Adherent::Member.stub(:find).with(@member.to_param).and_return @member
  end
    
  
  describe "GET index" do
    
    it 'rend la vue index' do
      @member.stub(:adhesions).and_return [1,2]
      get :index, member_id:@member.to_param
      response.should render_template("index")
    end
    
    it 'ou redirige vers new si pas d adhésion' do
      @member.stub(:adhesions).and_return []
      get :index, member_id:@member.to_param
      response.should redirect_to new_member_adhesion_url(assigns[:member])
    end
    

    it "assigns all coords as @coords" do
      @member.should_receive(:adhesions).and_return [1,2]
      get :index, member_id:@member.to_param
      assigns(:adhesions).should == [1,2]
    end
  end
  
  
  
  describe 'GET new' do
    
    it 'assigne une adhésion et rend la vue new' do
      @member.should_receive(:next_adhesion).and_return(@adh = mock_model(Adherent::Adhesion))
      get :new, member_id:@member.to_param
      assigns[:adhesion].should == @adh
      response.should render_template('new')
    end
    
  end
  
  describe "GET edit" do
    it 'appelle le payement' do
     @member.should_receive(:adhesions).and_return(@ar = double(Arel)) 
      @ar.should_receive(:find).with('1').and_return(@adh = mock_model(Adherent::Adhesion))
      get :edit, {member_id:@member.to_param, id:'1'}
    end
    
    it 'assigne le payment et rend la vue' do
      @member.stub_chain(:adhesions, :find).and_return(@adh = mock_model(Adherent::Adhesion))
      get :edit, {member_id:@member.to_param, id:'1'}
      assigns[:adhesion].should == @adh
      response.should render_template('edit')
    end
  end
  
  describe "POST create" do
    
    before(:each) do
      @attrib = {'amount'=>'57', 'mode'=>'CB', 'date'=>I18n.l(Date.today) }
    end
    
    it 'crée une nouvelle adhésion avec les params' do
      @member.should_receive(:adhesions).and_return(@ar = double(Arel)) 
      @ar.should_receive(:new).with(@attrib).and_return(@adh = mock_model(Adherent::Adhesion))
      @adh.should_receive(:save).and_return true
      post :create, {member_id:@member.to_param, :adhesion=>@attrib}
      
    end
    
    it 'renvoie vers la vue des adhésions' do
      @member.stub_chain(:adhesions, :new).and_return(@adh = mock_model(Adherent::Adhesion))
      @adh.stub(:save).and_return true
      post :create, {member_id:@member.to_param, :adhesion=>@attrib}
      response.should redirect_to(member_adhesions_url(assigns[:member]))
    end
    
    it 'et vers la vue new autrement' do
      @member.stub_chain(:adhesions, :new).and_return(@adh = mock_model(Adherent::Adhesion))
      @adh.stub(:save).and_return false
      post :create, {member_id:@member.to_param, :adhesion=>@attrib}
      response.should render_template('new')
    end
    
       
  end
  
  describe "POST update" do
    
    before(:each) do
      @adh = mock_model(Adherent::Adhesion)
      
    end
    
    it 'trouve le payment et appelle update_attributes' do
      @member.should_receive(:adhesions).and_return(@ar = double(Arel)) 
      @ar.should_receive(:find).with('1').and_return @adh
      @adh.should_receive(:update_attributes).with({'amount'=>'125'}).and_return true
      post :update, {member_id:@member.to_param, id:'1', :adhesion=>{:amount=>'125'} }
    end
    
    it 'redirige vers la liste des adhésions en cas de succès' do
      @member.stub_chain(:adhesions, :find).and_return @adh
      @adh.stub(:update_attributes).with({'amount'=>'125'}).and_return true
      post :update, {member_id:@member.to_param, id:'1', :adhesion=>{'amount'=>'125'} }
      response.should redirect_to(member_adhesions_url(assigns[:member]))
    end
    
    it 'et vers la vue edit autrement' do
      @member.stub_chain(:adhesions, :find).and_return @adh
      @adh.stub(:update_attributes).with({'amount'=>'125'}).and_return false
      post :update, {member_id:@member.to_param, id:'1', :adhesion=>{'amount'=>'125'} }
      response.should render_template 'edit'
    end
    
    it 'la variable @adhesion est assignée' do
      @member.stub_chain(:adhesions, :find).and_return @adh
      @adh.stub(:update_attributes).with({'amount'=>'125'}).and_return false
      post :update, {member_id:@member.to_param, id:'1', :adhesion=>{'amount'=>'125'} }
      assigns[:adhesion].should == @adh
    end
  end

 
  
  
end

