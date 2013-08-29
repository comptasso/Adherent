class Organism < ActiveRecord::Base
  attr_accessible :status, :title
  
  has_many :members, class_name:'Adherent::Member'
  has_many :payments, :through=>:members, class_name:'Adherent::Payment'
end
