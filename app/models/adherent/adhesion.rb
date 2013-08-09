

module Adherent
  class Adhesion < ActiveRecord::Base
    
    attr_accessible :from_date, :member, :to_date, :amount
    
    belongs_to :member
    has_many :reglements
    
    validates :from_date, :to_date, :member_id, presence:true
    validate :chrono_order
    
    pick_date_for :from_date, :to_date
    
    # partant d'une adhésion, retourne un hash avec les attributs correspondants à  
    # un renouvellement d'adhésion
    def self.next_adh_values(adh = nil)
      if adh
         {:from_date =>I18n.l(adh.read_attribute(:to_date)+1), :to_date=>I18n.l(adh.read_attribute(:to_date).years_since(1))} 
      else
         {:from_date=>I18n.l(Date.today), :to_date=>I18n.l(Date.today.years_since(1) - 1)}
      end
    end
    
    
    
    
    
    # indique si une adhésion a été réglée
    def is_paid?
      sprintf('%0.02f',due) == '0.00'
    end
    
    # retourne le montant dû sur l'adhésion
    def due
      amount - reglements.sum(:amount)
    end
    
    
    
    protected
    
    def chrono_order
      return unless (from_date && to_date) # on doit avoir les deux dates
      errors.add(:from_date, 'la date de début ne peut être après la date de fin') if read_attribute(:from_date) > read_attribute(:to_date)
    end
  end
end
