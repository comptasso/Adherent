# This migration comes from adherent (originally 20150412145132)
class CreateQueryMember < ActiveRecord::Migration
  def up 
    self.connection.execute %Q(CREATE OR REPLACE VIEW adherent_query_members AS
      SELECT adherent_members.id, organism_id, number, name, forname, birthdate,
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
      LEFT JOIN adherent_coords ON adherent_members.id = adherent_coords.member_id; 
    )
  end
  
  def down 
    self.connection.execute "DROP VIEW IF EXISTS adherent_query_members"
  end
end
