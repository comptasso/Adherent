class CreateAdherentAdherents < ActiveRecord::Migration
  def change
    create_table :adherent_adherents do |t|
      t.string :name
      t.string :forname
      t.date :birthdate
      t.string :number

      t.timestamps
    end
  end
end
