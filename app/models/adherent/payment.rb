module Adherent
  
  # La classe Payment permet d'enregistrer les payments effectués par les adhérents
  # 
  # Un callback after_create tente d'imputer le réglement sur une adhésion qui soit due.
  # 
  # Comme il est possible qu'un adhérent fasse un réglement pour plusieurs personnes (les 
  # membres de sa famille par exemple), il est possible d'éclater des payments sur 
  # différents réglements. Un payment a donc plusieurs réglements.
  # 
  # Des méthodes non_impute et imputation_on_adh(adhesion) permettent de savoir 
  # si la totalité du payment a été affectée à un réglement et d'imputer le montant
  # sur une adhésion spécifiée.
  # 
  # Un validator spécifique est mis en place pour interdire de diminuer le payment 
  # en dessous des montants déja imputés.
  #
  class Payment < ActiveRecord::Base 
    
    has_many :reglements, :dependent=>:destroy
    belongs_to :member
    
    
    # attr_accessible :amount, :date, :mode
    
    validates :amount, :date, :mode, :member_id, presence:true
    validates :amount, :over_imputations=>true
    validates :comment, :format=>{with:NAME_REGEX},
      :length=>{:maximum=>LONG_NAME_LENGTH_MAX}, allow_blank: true
    
    
    before_save :correct_range_date
    
    pick_date_for :date 
    
    
    validates_numericality_of :amount
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
    
    # renvoie l'information sur le membre et le montant 
    # pour liste des imputations d'un paiement 
    def list_imputations
      reglements.collect do |r|
        name = r.try(:adhesion).try(:member).try(:to_s)
        name ||= 'Inconnue'
        {member:name, amount:r.amount, r_id:r.id}
      end
    end
    
    # calcule le montant du paiement qui n'a pas été imputé, donc qui 
    # ne correspond pas à des réglements
    def non_impute
      amount - impute
    end
    
    def impute
      reglements(true).sum(:amount)
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
    
    
    # vérifie que la date, si elle a changé est dans un range correct. 
    # Il appartient à l'application principale de définir ce range_correct
    # ici en surchargeant la méthode range_date de organism. 
    # TODO mettre plutôt ceci dans un fichier de configuration.
    def correct_range_date
      return true unless date_changed?
      if read_attribute(:date).in? member.organism.range_date
        return true
      else
        self.errors.add(:date, :out_of_range) 
        return false
      end
    end
    
    
    
  end
end
