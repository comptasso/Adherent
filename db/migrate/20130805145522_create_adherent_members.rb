class CreateAdherentMembers < ActiveRecord::Migration
  def change
    create_table :adherent_members do |t|
      t.string :number
      t.string :name
      t.string :forname
      t.date :birthdate

      t.timestamps
    end
  end
end
