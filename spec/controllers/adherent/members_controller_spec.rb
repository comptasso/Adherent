# coding utf-8

require 'rails_helper'

RSpec.configure do |c|
  # c.exclusion_filter = {js:true}
  # c.filter = {wip:true}
end

describe Adherent::MembersController, :type => :controller do
  
  before(:each) do
    @routes = Adherent::Engine.routes 
  end
  
  describe 'test fixtures', focus:true do 
    it 'a un organisme' do
      @o = organisms(:asso_1)
    end
  end
  
  describe "GET index" do
        
    it 'rend la vue index' do
      get :index
      expect(response).to render_template("index")
    end
    

    it "assigns all members as @members" do
      expect(Adherent::Member).to receive(:query_members).and_return([1,2])
      get :index
      expect(assigns(:members)).to eq([1,2])
    end
    
    it 'peut rendre un csv' do
      expect {get :index, format:'csv'}.not_to raise_error
    end
    
    it 'ou un xls' do
      expect {get :index, format:'xls'}.not_to raise_error
    end
  end
  
  describe "GET show" do
    controller do
      
      
      def find_member
        Adherent::Member.new
      end
    end
     
    it 'assigne le membre et rend la vue' do
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
    
    controller do
      def find_member
        @m = Adherent::Member.new
      end
    end
        
    it 'assigne le membre et rend la vue' do
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
  
  describe "POST update", wip:true do
    
    before(:each) do
      @member = Adherent::Member.new(name:'Dupont',forname:'Jules', number:'A002')
      @member.organism_id = 1
      puts @member.errors.messages unless @member.valid?
      @member.save
      allow(Adherent::Member).to receive(:find).with(@member.to_param).
        and_return @member
    end   
    
    controller do
      def find_member
        @member = Adherent::Member.new(name:'Dupont',forname:'Jules', number:'A002')
        @member.organism_id = 1
        puts @member.errors.messages unless @member.valid?
        @member.save
        @member
      end
    end
    
    it 'appelle update_attributes' do
      expect(@member).to receive(:update_attributes).with({'name'=>'Dalton'}).and_return true
      post :update, {id:@member.to_param, :member=>{:name=>'Dalton'} }
    end
    
    it 'redirige vers show en cas de succès' do
      allow(@member).to receive(:update_attributes).and_return true
      post :update, {id:@member.to_param, :member=>{:name=>'Dalton'} }
      expect(response).to redirect_to(member_url(@member))
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
      @member = double(Adherent::Member)
    end
    
    it 'trouve le member demandé' do
      allow(@member).to receive(:destroy)
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