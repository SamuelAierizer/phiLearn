class LateDelete < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deleted_at, :datetime
    add_column :schools, :deleted_at, :datetime
    add_column :courses, :deleted_at, :datetime
    add_column :lectures, :deleted_at, :datetime
    add_column :assignments, :deleted_at, :datetime
    add_column :solutions, :deleted_at, :datetime
    add_column :questions, :deleted_at, :datetime
    add_column :answers, :deleted_at, :datetime
    add_column :resources, :deleted_at, :datetime
    add_column :question_options, :deleted_at, :datetime
    add_column :comments, :deleted_at, :datetime
    add_column :forums, :deleted_at, :datetime
    add_column :topics, :deleted_at, :datetime
    add_column :posts, :deleted_at, :datetime
  end
end
