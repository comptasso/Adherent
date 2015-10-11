# coding utf-8

require 'rails_helper'

describe Adherent::PaymentsController, :type => :controller do
  
  fixtures :all
  
  before(:each) do
    @routes = Adherent::Engine.routes
    @member = adherent_members(:Dupont)
    allow(@controller).to receive(:guess_date).and_return Date.today
  end
    
  
  describe "GET index" do
        
    it 'rend la vue index' do
      get :index, member_id:@member.to_param
      expect(response).to render_template("index")
    end

    it "assigns all coords as @coords" do
      get :index, member_id:@member.to_param
      expect(assigns(:payments)).to eq(@member.payments)  
    end
  end
  
  
  
  describe 'GET new' do 
    
    it 'assigne un payments et rend la vue new' do
      get :new, member_id:@member.to_param
      expect(assigns[:payment]).to be_a_new(Adherent::Payment)
      expect(assigns[:payment].member_id).to eq @member.id
      expect(response).to render_template('new') 
    end
    
  end
  
  
  describe "POST create" do
    
    before(:each) do
      @attrib = {'amount'=>'57', 'mode'=>'CB', 'date'=>I18n.l(Date.today) }
    end
    
    it 'crée une nouvelle adhésion avec les params' do
      expect {
      post :create, {member_id:@member.to_param, :payment=>@attrib} }.
      to change {Adherent::Payment.count}.by 1
      
    end
    
    it 'renvoie vers la vue des adhésions' do
      post :create, {member_id:@member.to_param, :payment=>@attrib}
      expect(response).to redirect_to(member_payments_url(@member))
    end
    
    it 'et vers la vue new autrement' do
      post :create, {member_id:@member.to_param,
        :payment=>{'mode'=>'CB', 'date'=>I18n.l(Date.today) } }
      expect(response).to render_template('new')
    end
    
       
  end
  
  describe "GET show"  do  
    
    it 'rend la vue show' do
      m = adherent_members(:Fidele)  
      pay = adherent_payments(:pay_2) 
      get :show, member_id:m.to_param , id:pay.to_param
      expect(assigns[:payment]).to eq(pay)
      expect(response).to render_template('show') 
    end
  end

 
  
  
end

