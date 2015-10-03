# coding utf-8

require 'rails_helper'

RSpec.configure do |c|
 # c.exclusion_filter = {js:true}
 #  c.filter = {wip:true}
end

describe Adherent::CoordsController, :type => :controller do
  
  before(:each) do
   @routes = Adherent::Engine.routes
   @member = double(Adherent::Member)
   allow(@controller).to receive(:find_member)
   @controller.instance_variable_set('@member', @member)
  end
    
  
  
  
  describe "GET show" do
    it 'appelle le coord' , wip:true do
      expect(@member).to receive(:coord).and_return(double(Adherent::Coord))
      get :show, {member_id:@member.to_param}
      assigns.each {|h| puts "#{h.inspect }"}
    end
    
    it 'assigne le membre et rend la vue' do
      allow(@member).to receive(:coord).and_return(@coord = double(Adherent::Coord))
      get :show, member_id:@member.to_param
      expect(assigns[:coord]).to eq(@coord)
      expect(response).to render_template('show')
    end
  end
  
  describe 'GET new' do
    
    it 'assigne un coord et rend la vue new' do
      expect(@member).to receive(:build_coord).and_return(@coord = double(Adherent::Coord))
      get :new, member_id:@member.to_param
      expect(assigns[:coord]).to eq(@coord)
      expect(response).to render_template('new')
    end
    
  end
  
  describe "GET edit" do
    it 'appelle le coord' do
      expect(@member).to receive(:coord).and_return(@coord = double(Adherent::Coord))
      get :edit, member_id:@member.to_param
    end
    
    it 'assigne le membre et rend la vue' do
      allow(@member).to receive(:coord).and_return(@coord = double(Adherent::Coord))
      get :edit, member_id:@member.to_param
      expect(assigns[:coord]).to eq(@coord)
      expect(response).to render_template('edit')
    end
  end
  
  describe "POST create" do
    
    before(:each) do
      @attrib = {'city'=>'Bruxelles', 'zip'=>'1000'}
    end
    
    it 'redirige vers new adhesion en cas de succès' do
      expect(@member).to receive(:build_coord).with(@attrib).and_return(@coord = double(Adherent::Coord))
      expect(@coord).to receive(:save).and_return true
      post :create, member_id:@member.to_param, :coord=>@attrib
      expect(response).to redirect_to(new_member_adhesion_url(assigns[:member]))
    end
    
    it 'et vers la vue new autrement' do
      expect(@member).to receive(:build_coord).with(@attrib).and_return(@coord = double(Adherent::Coord))
      expect(@coord).to receive(:save).and_return false
      post :create, member_id:@member.to_param, :coord=>@attrib
      expect(response).to render_template 'new'
    end
    
       
  end
  
  describe "POST update" do
    
    before(:each) do
      @coord = double(Adherent::Coord)
      allow(@member).to receive(:coord).and_return @coord
    end
    
    it 'appelle update_attributes' do
      expect(@coord).to receive(:update_attributes).with({'city'=>'Dallas'}).and_return true
      post :update, {member_id:@member.to_param, :coord=>{:city=>'Dallas'} }
    end
    
    it 'redirige vers show en cas de succès' do
      allow(@coord).to receive(:update_attributes).with({'city'=>'Dallas'}).and_return true
      post :update, {member_id:@member.to_param, :coord=>{:city=>'Dallas'} }
      expect(response).to redirect_to(member_coord_url(assigns[:member]))
    end
    
    it 'et vers la vue edit autrement' do
      allow(@coord).to receive(:update_attributes).with({'city'=>'Dallas'}).and_return false
      post :update, {member_id:@member.to_param, :coord=>{:city=>'Dallas'} }
      expect(response).to render_template 'edit'
    end
    
    it 'la variable @member est assignée' do
      allow(@coord).to receive(:update_attributes).with({'city'=>'Dallas'}).and_return false
      post :update, {member_id:@member.to_param, :coord=>{:city=>'Dallas'} }
      expect(assigns[:coord]).to eq(@coord)
    end
  end

 
  
  
end
