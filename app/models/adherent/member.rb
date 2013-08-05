module Adherent
  class Member < ActiveRecord::Base
    attr_accessible :birthdate, :forname, :name, :number
  end
end
