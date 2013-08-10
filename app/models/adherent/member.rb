module Adherent
  class Member < ActiveRecord::Base
    attr_accessible :birthdate, :forname, :name, :number
    
    belongs_to :organism
    has_one :coord
    has_many :adhesions
    has_many :payments
    
    validates :number, :name, :forname , :presence=>true
    validates :number, :uniqueness=>true
    
    def unpaid_adhesions
      adhesions.reject {|adh| adh.is_paid? }
    end
    
    def unpaid_adhesions?
      unpaid_adhesions.any?
    end
    
    def unpaid_amount
      unpaid_adhesions.sum(&:due)
    end
    
    def to_s
      [forname, name.capitalize].join(' ')
    end
    
    def next_adhesion
      adh = adhesions(true).order('to_date').last
      n_ad =  Adhesion.next_adh_values(adh)
      adhesions.new(n_ad)
    end
    
  end
end
