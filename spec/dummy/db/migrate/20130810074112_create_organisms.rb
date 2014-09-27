class CreateOrganisms < ActiveRecord::Migration
  def change
    create_table :organisms do |t|
      t.string :title
      t.string :status

      t.timestamps
    end
  end
end
