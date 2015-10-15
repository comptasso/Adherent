# coding: utf-8

require 'csv'

module Adherent
  class Member < ActiveRecord::Base
    

    pick_date_for :birthdate
    
    belongs_to :organism, class_name:'::Organism'
    has_one :coord, dependent: :destroy
    has_many :adhesions, dependent: :destroy
    has_many :payments
    
    # TODO rajouter un before_destroy sur les paiements
    
    validates :organism_id, :presence=>true
    validates :number, :format=>{with:NAME_REGEX}, :length=>{:within=>NAME_LENGTH_LIMITS}, :presence=>true
    validates_uniqueness_of  :number, :scope=>:organism_id
    validates :name, presence:true, :format=>{with:NAME_REGEX}, :length=>{:maximum=>LONG_NAME_LENGTH_MAX}
    validates :forname, presence:true, :format=>{with:NAME_REGEX}, :length=>{:maximum=>LONG_NAME_LENGTH_MAX}
    
    def self.query_members(organism)
      sql = <<-eof 
SELECT adherent_members.id, organism_id, number, name, forname, birthdate,
       adherent_coords.mail AS mail,
       adherent_coords.tel AS tel,
       adherent_coords.gsm AS gsm,
       adherent_coords.office AS office,
       adherent_coords.address AS address,
       adherent_coords.zip AS zip,
       adherent_coords.city AS city,
      (SELECT to_date FROM adherent_adhesions
         WHERE adherent_adhesions.member_id = adherent_members.id
         ORDER BY to_date DESC LIMIT 1 ) AS m_to_date,
      (SELECT SUM(adherent_reglements.amount) FROM adherent_reglements,
         adherent_adhesions
       WHERE adherent_reglements.adhesion_id = adherent_adhesions.id AND
         adherent_adhesions.member_id = adherent_members.id) AS t_reglements,
      (SELECT SUM(amount) FROM adherent_adhesions
         WHERE adherent_adhesions.member_id = adherent_members.id) AS t_adhesions, 
      (SELECT COUNT(*) FROM adherent_payments
         WHERE adherent_payments.member_id = adherent_members.id) AS nb_payments
         
      FROM adherent_members 
      LEFT JOIN adherent_coords ON adherent_members.id = adherent_coords.member_id
      WHERE organism_id = #{organism.id} 
    eof
       find_by_sql(sql)      
    end
    
    # arel des adhésions impayées par ordre de date
    def unpaid_adhesions
      adhesions.order(:to_date).unpaid
    end
    
    # indique s'il y a des adhésions impayées pour ce membre
    def unpaid_adhesions?
      unpaid_adhesions.any?
    end
    
    # donne le montant total des adhésions impayées
    def unpaid_amount
      unpaid_adhesions.to_a.sum(&:due)
    end
    
    
    
    # renvoie le prenom NOM
    def to_s
      [forname, name.upcase].join(' ')
    end
    
    # indique la date de fin de son adhésion actuelle.
    # S'il n'y a pas d'adhésion, on prend la date de création du membre
    # 
    # On n'a qu'un I18n::l car le to_date de last_adhesion est déja mis
    # au format par le module pick_date_extension
    #
    def jusquau
      la = last_adhesion
      la ? la.to_date : I18n::l(created_at.to_date)
    end
    
    # renvoie une nouvelle adhésion préremplie avec les éléments issus de la
    # dernière adhésion.
    # il est possible d'imposer le montant si nécessaire
    def next_adhesion(amount = nil)
      amount ||= 0
      adh = adhesions(true).order('to_date').last
      if adh
        vals =  adh.next_adh_values(amount)
      else
        vals = Adhesion::next_adh_values(amount)
      end
      adhesions.new(vals)
    end
    
    # montant dû par l'adhérent pour ses adhésions
    def montant_du
      tadh = t_adhesions ? BigDecimal.new(t_adhesions, 2) : BigDecimal.new(0.0, 2)
      treg = t_reglements ? BigDecimal.new(t_reglements, 2) : BigDecimal.new(0.0, 2)
      tadh - treg
    end
    
    # booléen indiquant si l'adhérent est à jour de ces cotisations
    def a_jour?
      montant_du <= 0.001
    end
    
    # edition en csv des membres d'un organisme dont l'id est 
    # transmis en argument
    def self.to_csv(organism, options = {col_sep:"\t"})
      ms = query_members(organism)
      CSV.generate(options) do |csv|
        csv << ['Numero', 'Nom', 'Prénom', 'Date de naissance',
          'Mail', 'Tél', 'Gsm', 'Bureau', 'Adresse', 'Code Postal', 'Ville', 'Doit', 'Fin Adh.']
        ms.each do |m| 
          csv << [m.number, m.name, m.forname, m.birthdate, m.mail, m.tel,
            m.gsm, m.office, m.address, m.zip, m.city,
            ActiveSupport::NumberHelper.number_to_rounded(m.montant_du, precision:2),
            m.jusko]
        end
      end
    end
    
    # Pour avoir l'encodage Windows, voir à mettre dans un module si 
    # répété avec d'autres modèles
    def self.to_xls(organism, options = {col_sep:"\t"})
      to_csv(organism, options).encode("windows-1252")
    end
    
    def jusko
      I18n::l m_to_date if m_to_date
    end
    
    protected
    
    
        
    def last_adhesion
      adhesions.order('to_date').last
    end
    
    
  end
end
