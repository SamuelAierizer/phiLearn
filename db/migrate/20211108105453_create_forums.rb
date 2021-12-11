class CreateForums < ActiveRecord::Migration[6.1]
  def change
    create_table :forums do |t|
      t.integer :forumable_id
      t.integer :forumable_type

      t.timestamps
    end

    add_column :schools, :school_forum, :boolean, :default => false
    add_column :schools, :course_forum, :boolean, :default => false
  end
end
