# coding utf-8

require 'spec_helper'

describe Adherent::MembersController, :type => :controller do
  
  before(:each) do
   @routes = Adherent::Engine.routes 
  end
    
  
  describe "GET index" do
    
    
    
    it 'rend la vue index' do
      get :index
      expect(response).to render_template("index")
    end
    

    it "assigns all members as @members" do
      expect_any_instance_of(Organism).to receive(:members).and_return(@ar = double(Arel))
      expect(@ar).to receive(:all).and_return [1,2]
      get :index
      expect(assigns(:members)).to eq([1,2])
  
    end
  end
  
  describe "GET show" do
    it 'appelle le membre' do
      expect(Adherent::Member).to receive(:find).with('999').and_return(mock_model(Adherent::Member))
      get :show, {id:'999'}
    end
    
    it 'assigne le membre et rend la vue' do
      allow(Adherent::Member).to receive(:find).with('998').and_return(@m = mock_model(Adherent::Member))
      get :show, {id:'998'}
      expect(assigns[:member]).to eq(@m)
      expect(response).to render_template('show')
    end
  end
  
  describe 'GET new' do
    
    it 'assigne un membre et rend la vue new' do
      get :new
      expect(assigns[:member]).to be_an_instance_of(Adherent::Member)
      expect(response).to render_template('new')
    end
    
  end
  
  describe "GET edit" do
    it 'appelle le membre' do
      expect(Adherent::Member).to receive(:find).with('999').and_return(mock_model(Adherent::Member))
      get :edit, {id:'999'}
    end
    
    it 'assigne le membre et rend la vue' do
      allow(Adherent::Member).to receive(:find).with('998').and_return(@m = mock_model(Adherent::Member))
      get :edit, {id:'998'}
      expect(assigns[:member]).to eq(@m)
      expect(response).to render_template('edit')
    end
  end
  
  describe "POST create" do
    
    before(:each) do
      @attrib = {name:'Dupont', forname:'Jules', number:'A001'}
    end
    
    it 'redirige vers index en cas de succès' do
      post :create,  :member=>@attrib
      expect(response).to redirect_to(new_member_coord_url(assigns[:member]))
    end
    
    it 'et vers la vue new autrement' do
      allow_any_instance_of(Adherent::Member).to receive(:save).and_return false
      post :create,  :member=>@attrib
      expect(response).to render_template 'new'
    end
    
    it 'le member créé est correct' do
      post :create,  :member=>@attrib
      expect(assigns[:member].name).to eq('Dupont')
      expect(assigns[:member].forname).to eq('Jules')
      expect(assigns[:member].number).to eq('A001')
    end
    
    it 'on peut enregistrer une date' do
      @attrib[:birthdate] = '06/06/1955'
      post :create,  :member=>@attrib
      expect(assigns[:member].birthdate).to eq('06/06/1955')
      expect(assigns[:member].read_attribute(:birthdate)).to eq(Date.civil(1955,6,6))
    end
    
    
  end
  
  describe "POST update" do
    
    before(:each) do
      @member = mock_model(Adherent::Member)
      allow(Adherent::Member).to receive(:find).with(@member.to_param).and_return @member
    end
    
    it 'appelle update_attributes' do
      expect(@member).to receive(:update_attributes).with({'name'=>'Dalton'}).and_return true
      post :update, {id:@member.to_param, :member=>{:name=>'Dalton'} }
    end
    
    it 'redirige vers show en cas de succès' do
      allow(@member).to receive(:update_attributes).and_return true
      post :update, {id:@member.to_param, :member=>{:name=>'Dalton'} }
      expect(response).to redirect_to(member_url(assigns[:member]))
    end
    
    it 'et vers la vue edit autrement' do
      allow(@member).to receive(:update_attributes).and_return false
      post :update,  {id:@member.to_param, :member=>{:name=>'Dalton'} }
      expect(response).to render_template 'edit'
    end
    
    it 'la variable @member est assignée' do
      allow(@member).to receive(:update_attributes).and_return true
      post :update,  {id:@member.to_param, :member=>{:name=>'Dalton'} }
      expect(assigns[:member]).to eq(@member)
    end
  end

  describe "DELETE destroy" do
    
    before(:each) do
      @member = mock_model(Adherent::Member)
    end
    
   it 'trouve le member demandé' do
     expect(Adherent::Member).to receive(:find).with(@member.to_param).and_return @member
     delete :destroy, {:id=>@member.to_param}
   end
   
    it 'le détruit et le redirige vers la vue index' do
      allow(Adherent::Member).to receive(:find).with(@member.to_param).and_return @member
      expect(@member).to receive(:destroy).and_return true 
      delete :destroy, {:id=>@member.to_param}
      expect(response).to redirect_to members_url
    end

  end
  
  
end