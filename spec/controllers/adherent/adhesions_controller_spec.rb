# coding utf-8 

require 'rails_helper'


RSpec.describe Adherent::AdhesionsController, :type => :controller do
  
  before(:each) do
   @routes = Adherent::Engine.routes 
   @member = double(Adherent::Member)
   allow(Adherent::Member).to receive(:find).with(@member.to_param).and_return @member
  end
    
  
  describe "GET index" do
    
    it 'rend la vue index' do
      allow(@member).to receive(:adhesions).and_return [1,2]
      get :index, member_id:@member.to_param
      expect(response).to render_template("index")
    end
    
    it 'ou redirige vers new si pas d adhésion' do
      allow(@member).to receive(:adhesions).and_return []
      get :index, member_id:@member.to_param
      expect(response).to redirect_to new_member_adhesion_url(assigns[:member])
    end
    

    it "assigns all coords as @coords" do
      expect(@member).to receive(:adhesions).and_return [1,2]
      get :index, member_id:@member.to_param
      expect(assigns(:adhesions)).to eq([1,2])
    end
  end
  
  
  
  describe 'GET new' do
    
    it 'assigne une adhésion et rend la vue new' do
      expect(@member).to receive(:next_adhesion).and_return(@adh = double(Adherent::Adhesion))
      get :new, member_id:@member.to_param
      expect(assigns[:adhesion]).to eq(@adh)
      expect(response).to render_template('new')
    end
    
  end
  
  describe "GET edit" do
    it 'appelle le payement' do
     expect(@member).to receive(:adhesions).and_return(@ar = double(Arel)) 
      expect(@ar).to receive(:find).with('1').and_return(@adh = double(Adherent::Adhesion))
      get :edit, {member_id:@member.to_param, id:'1'}
    end
    
    it 'assigne le payment et rend la vue' do
      allow(@member).to receive(:adhesions).and_return @ar = double(Arel)
      allow(@ar).to receive(:find).and_return(@adh = double(Adherent::Adhesion))
      get :edit, {member_id:@member.to_param, id:'1'}
      expect(assigns[:adhesion]).to eq(@adh)
      expect(response).to render_template('edit')
    end
  end
  
  describe "POST create" do
    
    before(:each) do
      @attrib = {'amount'=>'57', 'mode'=>'CB', 'date'=>I18n.l(Date.today) }
    end
    
    it 'crée une nouvelle adhésion avec les params' do 
      expect(@member).to receive(:adhesions).and_return(@ar = double(Arel)) 
      expect(@ar).to receive(:new).with(@attrib).
        and_return(@adh = double(Adherent::Adhesion, valid?:true))
      expect(@adh).to receive(:save).and_return true 
      post :create, {member_id:@member.to_param, :adhesion=>@attrib}
      
    end
    
    it 'renvoie vers la vue des adhésions' do 
      allow(@member).to receive(:adhesions).and_return(@ar = double(Arel))
      allow(@ar).to receive(:new).
        and_return(@adh = double(Adherent::Adhesion, valid?:true))
      allow(@adh).to receive(:save).and_return true
      post :create, {member_id:@member.to_param, :adhesion=>@attrib}
      expect(response).to redirect_to(member_adhesions_url(assigns[:member]))
    end
    
    it 'et vers la vue new autrement' do
      allow(@member).to receive(:adhesions).and_return(@ar = double(Arel))
      allow(@ar).to receive(:new).
        and_return(@adh = Adherent::Adhesion.new) # qui est un invalide
      allow(@adh).to receive(:save).and_return false
      post :create, {member_id:@member.to_param, :adhesion=>@attrib}
      expect(response).to render_template('new')
    end
    
       
  end
  
  describe "POST update" do
    
    before(:each) do
      @adh = double(Adherent::Adhesion)
      
    end
    
    it 'trouve le payment et appelle update_attributes' do
      expect(@member).to receive(:adhesions).and_return(@ar = double(Arel)) 
      expect(@ar).to receive(:find).with('1').and_return @adh
      expect(@adh).to receive(:update_attributes).with({'amount'=>'125'}).and_return true
      post :update, {member_id:@member.to_param, id:'1', :adhesion=>{:amount=>'125'} }
    end
    
    it 'redirige vers la liste des adhésions en cas de succès' do
       allow(@member).to receive(:adhesions).and_return @ar = double(Arel)
      allow(@ar).to receive(:find).and_return(@adh = double(Adherent::Adhesion))
      allow(@adh).to receive(:update_attributes).with({'amount'=>'125'}).and_return true
      post :update, {member_id:@member.to_param, id:'1', :adhesion=>{'amount'=>'125'} }
      expect(response).to redirect_to(member_adhesions_url(assigns[:member]))
    end
    
    it 'et vers la vue edit autrement' do
       allow(@member).to receive(:adhesions).and_return @ar = double(Arel)
      allow(@ar).to receive(:find).and_return(@adh = double(Adherent::Adhesion))
      allow(@adh).to receive(:update_attributes).with({'amount'=>'125'}).and_return false
      post :update, {member_id:@member.to_param, id:'1', :adhesion=>{'amount'=>'125'} }
      expect(response).to render_template 'edit'
    end
    
    it 'la variable @adhesion est assignée' do
       allow(@member).to receive(:adhesions).and_return @ar = double(Arel)
      allow(@ar).to receive(:find).and_return(@adh = double(Adherent::Adhesion))
      allow(@adh).to receive(:update_attributes).with({'amount'=>'125'}).and_return false
      post :update, {member_id:@member.to_param, id:'1', :adhesion=>{'amount'=>'125'} }
      expect(assigns[:adhesion]).to eq(@adh)
    end
  end

 
  
  
end

