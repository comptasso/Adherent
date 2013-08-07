module Adherent
  class Member < ActiveRecord::Base
    attr_accessible :birthdate, :forname, :name, :number
    
    has_one :coord
    has_many :adhesions
    
    validates :number, :name, :forname , :presence=>true
    validates :number, :uniqueness=>true
    
    def to_s
      [forname, name.capitalize].join(' ')
    end
    
  end
end
