# coding utf-8

require 'rails_helper'

describe 'Coord', :type => :model do 
  before(:each) do
    @m = mock_model(Adherent::Member)
  end
  
  it 'les coordonnées sont rattachées à un membre' do
    @c = Adherent::Coord.new()
    @c.valid?
    expect(@c.errors[:member_id].size).to eq(1)
    
  end
  
  it 'coord est dépendant du membre' do
    m = Adherent::Member.new(number:'Adh1', name:'James', forname:'Jessie')
    m.organism_id = 1
    m.save
    @c = m.create_coord(city:'Lille', zip:59000)
    expect(Adherent::Coord.count).to eq(1)
    m.destroy
    expect(Adherent::Coord.count).to eq(0)
  end
end