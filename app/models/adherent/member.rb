module Adherent
  class Member < ActiveRecord::Base
    attr_accessible :birthdate, :forname, :name, :number
    
    pick_date_for :birthdate
    
    belongs_to :organism, class_name: 'Organism'
    has_one :coord, dependent: :destroy
    has_many :adhesions
    has_many :payments
    
    validates :number, :name, :forname , :organism_id, :presence=>true
    validates_uniqueness_of  :number, :scope=>:organism_id
    
    # array des adhésions impayées par ordre de date
    def unpaid_adhesions
      adhesions.order(:to_date).reject {|adh| adh.is_paid? }
    end
    
    # indique s'il y a des adhésions impayées pour ce membre
    def unpaid_adhesions?
      unpaid_adhesions.any?
    end
    
    # donne le montant total des adhésions impayées
    def unpaid_amount
      unpaid_adhesions.sum(&:due)
    end
    
    # renvoie le prenom NOM
    def to_s
      [forname, name.upcase].join(' ')
    end
    
    # renvoie une nouvelle adhésion préremplie avec les éléments issus de la
    # dernière adhésion
    def next_adhesion
      adh = adhesions(true).order('to_date').last
      n_ad =  Adhesion.next_adh_values(adh)
      adhesions.new(n_ad)
    end
    
  end
end
