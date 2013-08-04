module Adherent
  class Adherent < ActiveRecord::Base
    attr_accessible :birthdate, :forname, :name, :number
    
    validates :name, :number, :forname, :presence=>true
    
    pick_date_for :birthdate
  end
end
