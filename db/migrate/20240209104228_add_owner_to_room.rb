class AddOwnerToRoom < ActiveRecord::Migration[7.1]
  def change
    add_reference :rooms, :owner, null: true, foreign_key: { to_table: :users }
  end
end
