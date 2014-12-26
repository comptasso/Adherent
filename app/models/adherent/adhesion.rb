

module Adherent
  class Adhesion < ActiveRecord::Base
    
   # attr_accessible :from_date, :to_date, :amount
    
    belongs_to :member
    has_many :reglements
    
    validates :from_date, :to_date, :member_id, :amount, presence:true
    validates_numericality_of :amount, greater_than_or_equal_to: 0
    validate :chrono_order
    
    pick_date_for :from_date, :to_date
    
    # partant d'une adhésion, retourne un hash avec les attributs correspondants à  
    # un renouvellement d'adhésion. 
    # S'il n'y pas d'adhésion, fonctionne avec des valeurs par défaut
    def self.next_adh_values(montant = 0)
       {:from_date =>I18n.l(Date.today),
           :to_date=>I18n.l(Date.today.years_since(1) -1 ),
           amount: montant
           } 
    end
    
    def next_adh_values(montant = 0)
         montant = amount if montant == 0
        {:from_date =>I18n.l(read_attribute(:to_date)+1),
           :to_date=>I18n.l(read_attribute(:to_date).years_since(1)),
           amount: montant
           } 
    end
    
    # liste toutes les adhésions qui ne sont pas payées.
    # pour rappel un where ne fonctionne pas avec un aggrégat obligeant à utiliser la clause having
    # reglements_amount.to_i donne le montant des règlements enregistrés
    # to_i est nécessaire car le retour fait par Rails est un string
    scope :unpaid, select('adherent_adhesions.*, sum(adherent_reglements.amount) as reglements_amount').
        joins('left join adherent_reglements on adherent_reglements.adhesion_id = adherent_adhesions.id').
        group('adherent_adhesions.id').
        having('adherent_adhesions.amount > 0 AND (adherent_adhesions.amount > sum(adherent_reglements.amount) OR sum(adherent_reglements.amount) IS NULL)')
 
    
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
      puts r.errors.messages unless r.valid?
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
