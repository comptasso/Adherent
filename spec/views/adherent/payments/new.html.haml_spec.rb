require 'spec_helper'


describe "adherent/payments/new" do
  
  before(:each) do
    
    assign(:payment, stub_model(Adherent::Payment))
    assign(:member, stub_model(Adherent::Member, name:'Dupont', forname:'Jules'))
    view.stub(:member_payments_path).and_return 'bonjour'
    view.stub(:icon_to).and_return 'bonjour'
    view.stub(:member_payment_path).and_return 'bonjour'
  end
  
  it 'rend la vue' do
    
    render
  end

end