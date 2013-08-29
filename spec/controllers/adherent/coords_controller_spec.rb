# coding utf-8

require 'spec_helper'

describe Adherent::CoordsController do
  
  before(:each) do
   @routes = Adherent::Engine.routes
   @member = mock_model(Adherent::Member)
   Adherent::Member.stub(:find).with(@member.to_param).and_return @member
  end
    
  
  
  
  describe "GET show" do
    it 'appelle le coord' do
      @member.should_receive(:coord).and_return(mock_model(Adherent::Coord))
      get :show, member_id:@member.to_param
    end
    
    it 'assigne le membre et rend la vue' do
      @member.stub(:coord).and_return(@coord = mock_model(Adherent::Coord))
      get :show, member_id:@member.to_param
      assigns[:coord].should == @coord
      response.should render_template('show')
    end
  end
  
  describe 'GET new' do
    
    it 'assigne un coord et rend la vue new' do
      @member.should_receive(:build_coord).and_return(@coord = mock_model(Adherent::Coord))
      get :new, member_id:@member.to_param
      assigns[:coord].should == @coord
      response.should render_template('new')
    end
    
  end
  
  describe "GET edit" do
    it 'appelle le coord' do
      @member.should_receive(:coord).and_return(@coord = mock_model(Adherent::Coord))
      get :edit, member_id:@member.to_param
    end
    
    it 'assigne le membre et rend la vue' do
      @member.stub(:coord).and_return(@coord = mock_model(Adherent::Coord))
      get :edit, member_id:@member.to_param
      assigns[:coord].should == @coord
      response.should render_template('edit')
    end
  end
  
  describe "POST create" do
    
    before(:each) do
      @attrib = {'city'=>'Bruxelles', 'zip'=>'1000'}
    end
    
    it 'redirige vers new adhesion en cas de succès' do
      @member.should_receive(:build_coord).with(@attrib).and_return(@coord = mock_model(Adherent::Coord))
      @coord.should_receive(:save).and_return true
      post :create, member_id:@member.to_param, :coord=>@attrib
      response.should redirect_to(new_member_adhesion_url(assigns[:member]))
    end
    
    it 'et vers la vue new autrement' do
      @member.should_receive(:build_coord).with(@attrib).and_return(@coord = mock_model(Adherent::Coord))
      @coord.should_receive(:save).and_return false
      post :create, member_id:@member.to_param, :coord=>@attrib
      response.should render_template 'new'
    end
    
       
  end
  
  describe "POST update" do
    
    before(:each) do
      @coord = mock_model(Adherent::Coord)
      @member.stub(:coord).and_return @coord
    end
    
    it 'appelle update_attributes' do
      @coord.should_receive(:update_attributes).with({'city'=>'Dallas'}).and_return true
      post :update, {member_id:@member.to_param, :coord=>{:city=>'Dallas'} }
    end
    
    it 'redirige vers show en cas de succès' do
      @coord.stub(:update_attributes).with({'city'=>'Dallas'}).and_return true
      post :update, {member_id:@member.to_param, :coord=>{:city=>'Dallas'} }
      response.should redirect_to(member_coord_url(assigns[:member]))
    end
    
    it 'et vers la vue edit autrement' do
      @coord.stub(:update_attributes).with({'city'=>'Dallas'}).and_return false
      post :update, {member_id:@member.to_param, :coord=>{:city=>'Dallas'} }
      response.should render_template 'edit'
    end
    
    it 'la variable @member est assignée' do
      @coord.stub(:update_attributes).with({'city'=>'Dallas'}).and_return false
      post :update, {member_id:@member.to_param, :coord=>{:city=>'Dallas'} }
      assigns[:coord].should == @coord
    end
  end

 
  
  
end
