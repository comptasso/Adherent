class AddOrganismIdToAdherentMembers < ActiveRecord::Migration
  def change
    add_column :adherent_members, :organism_id, :integer
  end
end
