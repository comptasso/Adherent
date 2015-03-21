class AddCommentToPayment < ActiveRecord::Migration
  def change
    add_column :adherent_payments, :comment, :string
  end
end
