module Adherent
  class Member < ActiveRecord::Base
    attr_accessible :birthdate, :forname, :name, :number
    
    has_one :coord
    has_many :adhesions
    has_many :payments
    
    validates :number, :name, :forname , :presence=>true
    validates :number, :uniqueness=>true
    
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
