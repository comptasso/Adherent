require 'rails_helper'


describe "adherent/payments/new", :type => :view do
  
  before(:each) do
    
    assign(:payment, stub_model(Adherent::Payment))
    assign(:member, stub_model(Adherent::Member, name:'Dupont', forname:'Jules'))
    allow(view).to receive(:member_payments_path).and_return 'bonjour'
    allow(view).to receive(:icon_to).and_return 'bonjour'
    allow(view).to receive(:member_payment_path).and_return 'bonjour'
  end
  
  it 'rend la vue' do
    skip 'ne semble pas fonctionner dans un engine'
    render
  end

end