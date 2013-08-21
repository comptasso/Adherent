# coding utf-8


module Instances
  
  def create_member
    @member =  Adherent::Member.new(name:'James', forname:'Jessie', number:'001')
    @member.id = 1
    @member.save
    @member
  end
  
end