module Adherent
  class Coord < ActiveRecord::Base
    belongs_to :member
    
    attr_accessible :address, :city, :gsm, :mail, :office, :references, :tel, :zip
  end
end
