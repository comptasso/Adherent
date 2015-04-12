module Adherent
  # La classe QueryMember s'appuie sur une view de SQL appelée 
  # adherent_query_members. 
  # 
  # Elle reprend les principaux éléments de Member (organism_id, id, name,
  # forname, birthdate, et rajoute la date de la dernière adhésion (champ 
  # m_to_date), le montant total des adhésions dues (t_adhesions) et le montant
  # total des règlements (t_reglements).
  # 
  #  Ces deux derniers champts sont utilisés pour savoir si le membre est à 
  #  jour de ses paiements (méthode #a_jour?) 
  #
  class QueryMember < ActiveRecord::Base
    self.table_name = 'adherent_query_members'
    
    # juste pour avoir la remise en forme du champ birthdate
    # pour l'affichage
    pick_date_for :birthdate
    
    # booléen indiquant si l'adhérent est à jour de ces cotisations
    def a_jour?
      montant_du <= 0.001
    end
    
    # ici on aurait pu utiliser pick_date_for mais cela pose le problème 
    # des dates non remplies. Ce qui a son tour est gênant pour le tri dans 
    # les tables.
    def m_to_date
       td = read_attribute(:m_to_date)
       td.is_a?(Date) ? (I18n::l td) : I18n::l(Date.civil(2099, 12,31))
    end
    
    # montant dû par l'adhérent pour ses adhésions
    def montant_du
      tadh = t_adhesions ? BigDecimal.new(t_adhesions, 2) : BigDecimal.new(0.0, 2)
      treg = t_reglements ? BigDecimal.new(t_reglements, 2) : BigDecimal.new(0.0, 2)
      tadh - treg
    end
    
    protected 
    
    # forcément car basé sur une view sql
    def readonly?
      true
    end
  end
end