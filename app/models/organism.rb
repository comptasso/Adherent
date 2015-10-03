class Organism < ActiveRecord::Base
  
  
  has_many :members, class_name:'Adherent::Member'
  has_many :payments, through: :members, class_name:'Adherent::Payment'
  has_many :adhesions, through: :members, class_name:'Adherent::Adhesion'
  
  # méthode devant être surchargée dans l'application principale
  # pour avoir une capacité à gerer les limites de dates lors de la saisie des 
  # paiements
  #
  # Ici par défaut, on suppose que les dates correctes sont de 3 mois 
  # avant la date du jour et de 3 mois après
  # 
  # Dans l'appli compta, on redéfinit range_date pour avoir les dates 
  # correspondants aux exercices ouverts.
  def range_date
    Date.today.<<(3)..Date.today.>>(3)
  end
end
