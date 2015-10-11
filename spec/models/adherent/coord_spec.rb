# coding utf-8 

require 'rails_helper'

describe 'Coord', :type => :model do 
  fixtures :all
  
  before(:each) do
    @m = adherent_members(:Dupont) 
  end
  
  it 'les coordonnées sont rattachées à un membre' do
    @c = Adherent::Coord.new()
    @c.valid?
    expect(@c.errors[:member_id].size).to eq(1)
    
  end
  
  it 'coord est dépendant du membre' do
    expect{@m.create_coord(city:'Lille', zip:59000)}. 
      to change{Adherent::Coord.count}.by 1
  end
  
  it 'détruire le membre détruit ses coordonnées' do
    m = adherent_members(:Durand)
    expect{adherent_members(:Durand).destroy}.
      to change{Adherent::Coord.count}.by -1
  end
end