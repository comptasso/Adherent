module Adherent
  module PaymentsHelper
    def min_date 
      @member.organism.range_date.first
    end
    
    def max_date
      @member.organism.range_date.last
    end
  end
end
