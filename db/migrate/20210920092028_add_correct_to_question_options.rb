class AddCorrectToQuestionOptions < ActiveRecord::Migration[6.1]
  def change
    add_column :question_options, :correct, :boolean
  end
end
