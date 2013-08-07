

module Adherent
  class Adhesion < ActiveRecord::Base
    
    attr_accessible :from_date, :member, :to_date
    
    belongs_to :member
    validates :from_date, :to_date, :member_id, presence:true
    validate :chrono_order
    
    pick_date_for :from_date, :to_date
    
    
    
    protected
    
    def chrono_order
      return unless (from_date && to_date) # on doit avoir les deux dates
      errors.add(:from_date, 'la date de début ne peut être après la date de fin') if read_attribute(:from_date) > read_attribute(:to_date)
    end
  end
end
