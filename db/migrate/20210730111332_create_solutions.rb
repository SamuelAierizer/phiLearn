class CreateSolutions < ActiveRecord::Migration[6.1]
  def change
    create_table :solutions do |t|
      t.decimal :grade
      t.integer :user_id
      t.integer :assignment_id
      t.integer :course_id
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :solutions, [:user_id, :assignment_id], :unique => true
  end
end
