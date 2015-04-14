require 'csv'

module Adherent
  # La classe QueryMember s'appuie sur une view de SQL appelée 
  # adherent_query_members. 
  # 
  # Elle reprend les principaux éléments de Member (organism_id, id, name,
  # forname, birthdate, et rajoute la date de la dernière adhésion (champ 
  # m_to_date), le montant total des adhésions dues (t_adhesions) et le montant
  # total des règlements (t_reglements).
  # 
  #  Ces deux derniers champs sont utilisés pour savoir si le membre est à 
  #  jour de ses paiements (méthode #a_jour?) 
  #
  class QueryMember < ActiveRecord::Base
    
    
    
    def self.columns() @columns ||= []; end

    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end

    column :id, :integer
    column :organism_id, :integer
    column :number, :string
    column :name, :string
    column :forname, :string
    column :birthdate, :date
    column :m_to_date, :date
    column :t_adhesions, :decimal
    column :t_reglements, :decimal
    
    
    # juste pour avoir la remise en forme du champ birthdate
    # pour l'affichage
    pick_date_for :birthdate
    
    # booléen indiquant si l'adhérent est à jour de ces cotisations
    def a_jour?
      montant_du <= 0.001
    end
    
    def self.query_sql(organism)
      %Q(SELECT adherent_members.id, organism_id, number, name, forname, birthdate,
       adherent_coords.mail AS mail, adherent_coords.tel AS tel,
      (SELECT to_date FROM adherent_adhesions
         WHERE adherent_adhesions.member_id = adherent_members.id
         ORDER BY to_date DESC LIMIT 1 ) AS m_to_date,
      (SELECT SUM(adherent_reglements.amount) FROM adherent_reglements,
         adherent_adhesions
       WHERE adherent_reglements.adhesion_id = adherent_adhesions.id AND
         adherent_adhesions.member_id = adherent_members.id) AS t_reglements,
      (SELECT SUM(amount) FROM adherent_adhesions
         WHERE adherent_adhesions.member_id = adherent_members.id) AS t_adhesions
      FROM adherent_members 
      
      LEFT JOIN adherent_coords ON adherent_members.id = adherent_coords.member_id
      WHERE organism_id = #{organism.id}; 
    )
    end
    
    def self.query_members(organism)
      find_by_sql(query_sql(organism))
    end
    
    # ici on aurait pu utiliser pick_date_for mais cela pose le problème 
    # des dates non remplies. Ce qui a son tour est gênant pour le tri dans 
    # les tables.
    def m_to_date
      td = read_attribute(:m_to_date)
      td.is_a?(Date) ? (I18n::l td) : '31/12/2099' 
    end
    
    # montant dû par l'adhérent pour ses adhésions
    def montant_du
      tadh = t_adhesions ? BigDecimal.new(t_adhesions, 2) : BigDecimal.new(0.0, 2)
      treg = t_reglements ? BigDecimal.new(t_reglements, 2) : BigDecimal.new(0.0, 2)
      tadh - treg
    end
    
    # edition en csv des membres d'un organisme dont l'id est 
    # transmis en argument
    def self.to_csv(organism, options = {col_sep:"\t"})
      ms = query_members(organism)
      CSV.generate(options) do |csv|
        csv << ['Numero', 'Nom', 'Prénom', 'Date de naissance',
          'Mail', 'Tél', 'Montant dû', 'Fin Adh.']
        ms.each do |m|
          csv << [m.number, m.name, m.forname, m.birthdate, m.mail, m.tel,
            ActiveSupport::NumberHelper.number_to_rounded(m.montant_du, precision:2),
            m.m_to_date]
        end
      end
    end
    
    # Pour avoir l'encodage Windows, voir à mettre dans un module si 
    # répété avec d'autres modèles
    def self.to_xls(organism, options = {col_sep:"\t"})
      to_csv(organism, options).encode("windows-1252")
    end
    
    
    
    protected 
    
    # forcément car basé sur une view sql
    def readonly?
      true
    end
  end
end