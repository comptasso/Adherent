module Adherent
  class Adherent < ActiveRecord::Base
    attr_accessible :birthdate, :forname, :name, :number
  end
end
