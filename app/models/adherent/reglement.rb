module Adherent
  class Reglement < ActiveRecord::Base
    belongs_to :adhesion
    belongs_to :payment
    attr_accessible :amount
  end
end
