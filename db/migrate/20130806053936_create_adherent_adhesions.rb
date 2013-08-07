class CreateAdherentAdhesions < ActiveRecord::Migration
  def change
    create_table :adherent_adhesions do |t|
      t.date :from_date
      t.date :to_date
      t.references :member

      t.timestamps
    end
  end
end
