class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :answer_given
      t.integer :answers_type
      t.decimal :mark_achieved
      t.integer :solution_id
      t.string :question_id

      t.timestamps
    end
  end
end
