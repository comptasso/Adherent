module Adherent
  class Adhesion < ActiveRecord::Base
    attr_accessible :from_date, :member, :to_date
    
    belongs_to :member
    validates :from_date, :member_id, presence:true
    
    
    def from_date
      fd = read_attribute(:from_date)
      fd.is_a?(Date) ? (I18n::l fd) : fd
    end
    
    def from_date=(value)
      s  = value.split('/') if value
      date = Date.civil(*s.reverse.map{|e| e.to_i}) rescue nil
      if date && date > Date.civil(1900,1,1)
        write_attribute(:from_date, date)
      else
        value
      end
    end
    
    def to_date
      fd = read_attribute(:to_date)
      fd.is_a?(Date) ? (I18n::l fd) : fd
    end
    
    def to_date=(value)
      s  = value.split('/') if value
      date = Date.civil(*s.reverse.map{|e| e.to_i}) rescue nil
      if date && date > Date.civil(1900,1,1)
        write_attribute(:to_date, date)
      else
        value
      end
    end
  end
end
