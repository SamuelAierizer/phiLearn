class CreateSolutions < ActiveRecord::Migration[6.1]
  def change
    create_table :solutions do |t|
      t.decimal :grade
      t.string :file
      t.integer :user_id
      t.integer :assignment_id

      t.timestamps
    end

    add_index :solutions, :user_id
    add_index :solutions, :assignment_id
  end
end
