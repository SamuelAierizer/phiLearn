class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :question_asked
      t.string :answer
      t.integer :question_type
      t.decimal :mark_available
      t.integer :assignment_id

      t.timestamps
    end

    add_index :questions, :assignment_id
  end
end
