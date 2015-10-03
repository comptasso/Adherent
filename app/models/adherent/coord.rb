module Adherent
  class Coord < ActiveRecord::Base
    belongs_to :member
       
    validates :member_id, :presence=>true
    validates :tel, :format=>{with:NAME_REGEX}, 
      :length=>{:maximum=>LONG_NAME_LENGTH_MAX}, :allow_blank=>true
    validates :gsm, :format=>{with:NAME_REGEX}, 
      :length=>{:maximum=>LONG_NAME_LENGTH_MAX}, :allow_blank=>true
    validates :office, :format=>{with:NAME_REGEX}, 
      :length=>{:maximum=>LONG_NAME_LENGTH_MAX}, :allow_blank=>true
    validates :zip, :format=>{with:NAME_REGEX}, 
      :length=>{:maximum=>LONG_NAME_LENGTH_MAX}, :allow_blank=>true
    validates :city, :format=>{with:NAME_REGEX}, 
      :length=>{:maximum=>LONG_NAME_LENGTH_MAX}, :allow_blank=>true
    
  end
end
