module Adherent
  class Coord < ActiveRecord::Base
    belongs_to :member
    
    # attr_accessible :address, :city, :gsm, :mail, :office, :references, :tel, :zip
    
    validates :member_id, :presence=>true
    
    
  end
end
