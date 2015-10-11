# coding utf-8 

require 'rails_helper'

describe Adherent::AdhesionsController, :type => :controller do
  
  fixtures :all
  
  before(:each) do
   @routes = Adherent::Engine.routes 
   @member = adherent_members(:Dupont)
  end
    
  
  describe "GET index" do
    
    it 'rend la vue index' do
      get :index, member_id:@member.to_param
      expect(response).to render_template("index")
    end
    
    it 'ou redirige vers new si pas d adhésion' do
      get :index, member_id:adherent_members(:Durand).to_param
      expect(response).to redirect_to new_member_adhesion_url(assigns[:member])
    end
    

    it "assigns all coords as @coords" do
      get :index, member_id:@member.to_param
      expect(assigns(:adhesions)).to eq(@member.adhesions)
    end
  end
  
  
  
  describe 'GET new' do
    
    it 'assigne une adhésion et rend la vue new' do
      get :new, member_id:@member.to_param
      expect(assigns[:adhesion]).to be_an_instance_of(Adherent::Adhesion)
      expect(response).to render_template('new')
    end
    
  end
  
  describe "GET edit"do
        
    it 'assigne l adhesion et rend la vue' do
      a = @member.adhesions.first
      get :edit, {member_id:@member.to_param, id:a.to_param}
      expect(assigns[:adhesion]).to eq(a)
      expect(response).to render_template('edit')
    end
  end
  
  describe "POST create"  do
    
    before(:each) do
      @attrib = {'amount'=>'57', 'to_date'=>I18n.l(Date.today >> 12), 'from_date'=>I18n.l(Date.today) }
    end
    
    it 'crée une nouvelle adhésion avec les params' do 
      expect{(post :create, {member_id:@member.to_param, :adhesion=>@attrib})}.
        to  change{Adherent::Adhesion.count}.by(1)
      
    end
    
    it 'renvoie vers la vue des adhésions' do 
      post :create, {member_id:@member.to_param, :adhesion=>@attrib}
      expect(response).to redirect_to(member_adhesions_url(assigns[:member]))
    end
    
    it 'et vers la vue new autrement' do
      post :create, {member_id:@member.to_param, :adhesion=>{montant:10} }
      expect(response).to render_template('new')
    end
    
       
  end
  
  describe "POST update" do
    
    before(:each) do
      @member = adherent_members(:Dupont)
      @adh = @member.adhesions.first
    end
    
    it 'met à jour le paiement' do
      post :update, {member_id:@member.to_param, id:@adh.to_param, :adhesion=>{:amount=>'125'} }
      expect(adherent_adhesions(:adh_1).amount).to eq 125
    end
    
    it 'redirige vers la liste des adhésions en cas de succès' do
      post :update, {member_id:@member.to_param, id:@adh.to_param, :adhesion=>{'amount'=>'125'} }
      expect(response).to redirect_to(member_adhesions_url(assigns[:member]))
    end
    
    it 'et vers la vue edit autrement' do
      post :update, {member_id:@member.to_param, id:@adh.to_param, :adhesion=>{'amount'=>'bonjour'} }
      expect(response).to render_template 'edit'
    end
    
    it 'la variable @adhesion est assignée' do
      post :update, {member_id:@member.to_param, id:@adh.to_param, :adhesion=>{'amount'=>'125'} }
      expect(assigns[:adhesion]).to eq(@adh)
    end
  end

 
  
  
end

