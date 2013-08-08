class CreateAdherentAdhesions < ActiveRecord::Migration
  def change
    create_table :adherent_adhesions do |t|
      t.date :from_date
      t.date :to_date
      t.decimal :amount, precision: 10, scale: 2
      t.references :member

      t.timestamps
    end
    
    add_index :adherent_adhesions, :member_id
  end
end
