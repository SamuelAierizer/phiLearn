class CreateQuestionOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :question_options do |t|
      t.string :value
      t.integer :question_id
      t.boolean :correct

      t.timestamps
    end
  end
end
