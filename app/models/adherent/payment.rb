module Adherent
  class Payment < ActiveRecord::Base
    MODES = %w(CB Chèque Virement Espèces)
    
    has_many :adhesion
    belongs_to :member
    
    attr_accessible :amount, :date, :mode
    
    # le montant ne peut être que positif
    validates_numericality_of :amount, greater_than: 0
    # le mode doit être dans les MODES
    validates_inclusion_of :mode, in: MODES
    
  end
end
