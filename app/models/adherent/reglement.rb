module Adherent
  class Reglement < ActiveRecord::Base
    belongs_to :adhesion
    belongs_to :payment
    attr_accessible :amount
    
    validates :adhesion_id, :payment_id, :amount, presence:true
    validates_numericality_of :amount, greater_than:0.0
  end
end
