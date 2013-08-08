class AddColumnToAdherentAdhesions < ActiveRecord::Migration
  def change
    add_column :adherent_adhesions, :payment_id, :integer
    
    add_index :adherent_adhesions, :payment_id
    
    
  end
end
