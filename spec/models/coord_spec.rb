# coding utf-8

require 'spec_helper'

describe 'Coord' do 
  before(:each) do
    @m = mock_model(Adherent::Member)
  end
  
  it 'les coordonnées sont rattachées à un membre' do
    @c = Adherent::Coord.new()
    @c.valid?
    @c.should have(1).error_on(:member_id)
    
  end
  
  it 'coord est dépendant du membre' do
    m = Adherent::Member.new(number:'Adh1', name:'James', forname:'Jessie')
    m.organism_id = 1
    m.save
    @c = m.create_coord(city:'Lille', zip:59000)
    Adherent::Coord.count.should == 1
    m.destroy
    Adherent::Coord.count.should == 0
  end
end