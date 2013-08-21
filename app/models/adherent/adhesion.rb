

module Adherent
  class Adhesion < ActiveRecord::Base
    
    attr_accessible :from_date, :to_date, :amount
    
    belongs_to :member
    has_many :reglements
    
    validates :from_date, :to_date, :member_id, :amount, presence:true
    validates_numericality_of :amount, greater_than_or_equal_to: 0
    validate :chrono_order
    
    pick_date_for :from_date, :to_date
    
    # partant d'une adhésion, retourne un hash avec les attributs correspondants à  
    # un renouvellement d'adhésion. 
    # S'il n'y pas d'adhésion, fonctionne avec des valeurs par défaut
    def self.next_adh_values(adh = nil)
      if adh
         {:from_date =>I18n.l(adh.read_attribute(:to_date)+1),
           :to_date=>I18n.l(adh.read_attribute(:to_date).years_since(1)),
           amount: adh.amount
           } 
      else
         {:from_date=>I18n.l(Date.today),
           :to_date=>I18n.l(Date.today.years_since(1) - 1),
           amount:0
           }
      end
    end
    
    # liste toutes les adhésions qui ne sont pas payées
    # TODO voir pour faire une requête SQL ou un scope qui serait surment moins
    # consommatrice de mémoire
    def self.unpaid
      all.reject {|adh| adh.is_paid?}
    end
    
    # méthode mise en place pour assurer une mise en forme lisible
    # dans la sélection des imputations
    def to_s_for_select
      "#{member.to_s} - #{Adherent::ApplicationController.helpers.number_to_currency(due, locale: :fr)}"
    end
    
    
    
    # indique si une adhésion a été réglée
    def is_paid?
      sprintf('%0.02f',due) == '0.00'
    end
    
    # retourne le montant dû sur l'adhésion
    def due
      amount - received
    end
    
    def received
      reglements.sum(:amount)
    end
    
    # ajoute un réglement provenant d'un payment pour un montant donné;
    # renvoie le règlement qui a été ajouté.
    def add_reglement(payment_id, montant)
      imputation = [montant, due].min 
      r = reglements.new(amount:imputation)
      r.payment_id = payment_id
      r.save!
      r
    
    end
    
    
    
    protected
    
    def chrono_order
      return unless (from_date && to_date) # on doit avoir les deux dates
      errors.add(:from_date, 'la date de début ne peut être après la date de fin') if read_attribute(:from_date) > read_attribute(:to_date)
    end
  end
end
