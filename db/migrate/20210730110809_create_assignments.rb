class CreateAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :assignments do |t|
      t.string :name
      t.text :description
      t.integer :assignment_type
      t.datetime :deadline
      t.integer :course_id
      t.datetime :deleted_at

      t.timestamps
    end
    
    add_index :assignments, :course_id
  end
end
