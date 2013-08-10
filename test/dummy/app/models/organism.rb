class Organism < ActiveRecord::Base
  attr_accessible :status, :title
  
  has_many :members, class_name:'Adherent::Member'
end
