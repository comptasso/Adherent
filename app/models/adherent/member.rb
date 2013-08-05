module Adherent
  class Member < ActiveRecord::Base
    attr_accessible :birthdate, :forname, :name, :number
    
    has_one :coord
    
    pick_date_for :birthdate
    
    
  end
end
