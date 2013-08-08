class CreateAdherentAdhesions < ActiveRecord::Migration
  def change
    create_table :adherent_adhesions do |t|
      t.date :from_date
      t.date :to_date
      t.float :amount, precision: 10, scale: 2
      t.references :member

      t.timestamps
    end
  end
end
