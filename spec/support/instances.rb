# coding utf-8


module Instances
  
  def create_member(number = '001')
    @member =  Adherent::Member.new(name:'James', forname:'Jessie', number:number)
    @member.organism_id = 1
  #  puts @member.errors.messages unless @member.valid?
    @member.save!
    @member
  end
  
end