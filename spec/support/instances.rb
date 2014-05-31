# coding utf-8


module Instances
  
  def create_member(number = '001')
    create_organism
    @member =  @organism.members.new(name:'James', forname:'Jessie', number:number)
    
    #  puts @member.errors.messages unless @member.valid?
    @member.save!
    @member
  end
  
  def create_organism
    @organism = Organism.first || Organism.create!()
  end
  
end