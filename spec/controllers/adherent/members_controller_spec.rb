# coding utf-8

require 'spec_helper'

describe Adherent::MembersController do
  
  before(:each) do
   @routes = Adherent::Engine.routes 
  end
    
  
  describe "GET index" do
    
    
    
    it 'rend la vue index' do
      get :index
      response.should render_template("index")
    end
    

    it "assigns all members as @members" do
      Organism.any_instance.should_receive(:members).and_return(@ar = double(Arel))
      @ar.should_receive(:all).and_return [1,2]
      get :index
      assigns(:members).should == [1,2]
  
    end
  end
  
  describe "GET show" do
    it 'appelle le membre' do
      Adherent::Member.should_receive(:find).with('999').and_return(mock_model(Adherent::Member))
      get :show, {id:'999'}
    end
    
    it 'assigne le membre et rend la vue' do
      Adherent::Member.stub(:find).with('998').and_return(@m = mock_model(Adherent::Member))
      get :show, {id:'998'}
      assigns[:member].should == @m
      response.should render_template('show')
    end
  end
  
  describe 'GET new' do
    
    it 'assigne un membre et rend la vue new' do
      get :new
      assigns[:member].should be_an_instance_of(Adherent::Member)
      response.should render_template('new')
    end
    
  end
  
  describe "GET edit" do
    it 'appelle le membre' do
      Adherent::Member.should_receive(:find).with('999').and_return(mock_model(Adherent::Member))
      get :edit, {id:'999'}
    end
    
    it 'assigne le membre et rend la vue' do
      Adherent::Member.stub(:find).with('998').and_return(@m = mock_model(Adherent::Member))
      get :edit, {id:'998'}
      assigns[:member].should == @m
      response.should render_template('edit')
    end
  end
  
  describe "POST create" do
    
    before(:each) do
      @attrib = {name:'Dupont', forname:'Jules', number:'A001'}
    end
    
    it 'redirige vers index en cas de succès' do
      post :create,  :member=>@attrib
      response.should redirect_to(new_member_coord_url(assigns[:member]))
    end
    
    it 'et vers la vue new autrement' do
      Adherent::Member.any_instance.stub(:save).and_return false
      post :create,  :member=>@attrib
      response.should render_template 'new'
    end
    
    it 'le member créé est correct' do
      post :create,  :member=>@attrib
      assigns[:member].name.should == 'Dupont'
      assigns[:member].forname.should == 'Jules'
      assigns[:member].number.should == 'A001'
    end
    
    it 'on peut enregistrer une date' do
      @attrib[:birthdate] = '06/06/1955'
      post :create,  :member=>@attrib
      assigns[:member].birthdate.should == '06/06/1955'
      assigns[:member].read_attribute(:birthdate).should == Date.civil(1955,6,6)
    end
    
    
  end
  
  describe "POST update" do
    
    before(:each) do
      @member = mock_model(Adherent::Member)
      Adherent::Member.stub(:find).with(@member.to_param).and_return @member
    end
    
    it 'appelle update_attributes' do
      @member.should_receive(:update_attributes).with({'name'=>'Dalton'}).and_return true
      post :update, {id:@member.to_param, :member=>{:name=>'Dalton'} }
    end
    
    it 'redirige vers show en cas de succès' do
      @member.stub(:update_attributes).and_return true
      post :update, {id:@member.to_param, :member=>{:name=>'Dalton'} }
      response.should redirect_to(member_url(assigns[:member]))
    end
    
    it 'et vers la vue edit autrement' do
      @member.stub(:update_attributes).and_return false
      post :update,  {id:@member.to_param, :member=>{:name=>'Dalton'} }
      response.should render_template 'edit'
    end
    
    it 'la variable @member est assignée' do
      @member.stub(:update_attributes).and_return true
      post :update,  {id:@member.to_param, :member=>{:name=>'Dalton'} }
      assigns[:member].should == @member
    end
  end

  describe "DELETE destroy" do
    
    before(:each) do
      @member = mock_model(Adherent::Member)
    end
    
   it 'trouve le member demandé' do
     Adherent::Member.should_receive(:find).with(@member.to_param).and_return @member
     delete :destroy, {:id=>@member.to_param}
   end
   
    it 'le détruit et le redirige vers la vue index' do
      Adherent::Member.stub(:find).with(@member.to_param).and_return @member
      @member.should_receive(:destroy).and_return true 
      delete :destroy, {:id=>@member.to_param}
      response.should redirect_to members_url
    end

  end
  
  
end