class AddIndexToSolutions < ActiveRecord::Migration[6.1]
  def change
    add_index :solutions, [:user_id, :assignment_id], :unique => true
  end
end
