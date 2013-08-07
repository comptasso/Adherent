require 'adherent/pick_date_extension'

module Adherent
  class Adhesion < ActiveRecord::Base
    include Adherent::PickDateExtension
    attr_accessible :from_date, :member, :to_date
    
    belongs_to :member
    validates :from_date, :member_id, presence:true
    
    pick_date_for :from_date, :to_date
    
  
  end
end
