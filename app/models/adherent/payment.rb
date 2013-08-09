module Adherent
  class Payment < ActiveRecord::Base
    
    
    has_many :reglements
    belongs_to :member
    
    attr_accessible :amount, :date, :mode
    
    validates :amount, :date, :mode, presence:true
    
    pick_date_for :date
    
    # le montant ne peut être que positif
    validates_numericality_of :amount, greater_than: 0
    # le mode doit être dans les MODES
    validates_inclusion_of :mode, in: Adherent::MODES
    
  end
end
