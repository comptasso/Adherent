module Adherent
  class Payment < ActiveRecord::Base
    
    has_many :reglements, :dependent=>:destroy
    belongs_to :member
    
    attr_accessible :amount, :date, :mode
    
    validates :amount, :date, :mode, :member_id, presence:true
    
    pick_date_for :date
    
    # le montant ne peut être que positif
    validates_numericality_of :amount, greater_than: 0
    # le mode doit être dans les MODES
    validates_inclusion_of :mode, in: Adherent::MODES
    
    after_create :imputation
    
    # Pour faire une imputation sur une adhesion dont l'id est transmise en argument.
    # Utile lorsque le payment est fait par un membre pour payer l'adhésion d'un tiers
    # (par exemple un membre de sa famille).
    # TODO faire que la valeur de retour soit true ou false pour 
    # que la méthode créate du controller puisse tester et rediriger en conséquence
    def imputation_on_adh(adh_id)
      Adhesion.find(adh_id).add_reglement(id, non_impute)
    end
    
    # calcule le montant du paiement qui n'a pas été imputé, donc qui 
    # ne correspond pas à des réglements
    def non_impute
      amount - reglements(true).sum(:amount)
    end
    
    
    protected
    # quand on reçoit un paiement, il faut en réaliser l'imputation, 
    # plusieurs cas de figure sont à envisager.
    # 
    # Le cas le plus simple est lorsque le montant est inférieur ou égal aux  
    # montant dus par le membre pour les adhésions en cours.
    # 
    # Donc on impute sur les adhésions du membre non soldées en commençant par les 
    # plus anciennes. 
    # 
    # 
    def imputation
      # liste les adhésions non soldées et le montant total dû
      # pour chaque adhésion non soldée (prise dans l'ordre chrono)
      # on crée un réglement du montant dû dans la limité du montant du paiement.
      a_imputer = amount
      member.unpaid_adhesions.each  do |adh|
        if a_imputer > 0
          reglemt = adh.add_reglement(id, a_imputer)
          a_imputer -= reglemt.amount
        end
      end
    end
    
    
    
  end
end
