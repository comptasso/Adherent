# coding: utf-8

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
    
    
    # Permet en une seule requête de récupérer les données de la vue index 
    # avec l'id, le number, name, forname, mail, tel, l'échande de l'adhésion
    # (champ to_date), le montant des reglements reçus pour les adhésions de 
    # ce membre (champ t_reglements), le montant des adhésions de ce membre
    # champ (t_adhesions)
    def self.index_members
      sql= <<EOF
      SELECT adherent_members.id, number, name, forname, birthdate, adherent_coords.mail AS mail, adherent_coords.tel AS tel,
      (SELECT to_date FROM adherent_adhesions WHERE adherent_adhesions.member_id = adherent_members.id ORDER BY to_date DESC LIMIT 1 ) AS m_to_date,
      (SELECT SUM(adherent_reglements.amount) FROM adherent_reglements, adherent_adhesions WHERE adherent_reglements.adhesion_id = adherent_adhesions.id AND adherent_adhesions.member_id = adherent_members.id) AS t_reglements,
      (SELECT SUM(amount) FROM adherent_adhesions WHERE adherent_adhesions.member_id = adherent_members.id) AS t_adhesions
      FROM adherent_members LEFT JOIN adherent_coords ON adherent_members.id = adherent_coords.member_id;
EOF
      Adherent::Member.connection.execute( sql.gsub("\n", ''))
    end
    
    
    
    
    protected
    
    def last_adhesion
      adhesions.order('to_date').last
    end
    
    
  end
end
