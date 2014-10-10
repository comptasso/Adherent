require 'rails_helper'


describe "adherent/payments/new", :type => :view do
  routes {Adherent::Engine.routes}
  
  before(:each) do
    
    assign(:payment, double(Adherent::Payment))
    assign(:member, double(Adherent::Member, name:'Dupont', forname:'Jules'))
   # allow(view).to receive(:member_payments_path).and_return 'bonjour'
   # allow(view).to receive(:icon_to).and_return 'bonjour'
   # allow(view).to receive('member_payments_path').and_return 'bonjour'
  end
  
  it 'rend la vue' do
    render 
  end

end