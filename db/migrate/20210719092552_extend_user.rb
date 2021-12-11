class ExtendUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :role, :integer
    add_column :users, :profile_picture, :string
    add_column :users, :school_id, :integer

    remove_index :users, name:"index_users_on_email"

    add_index :users, :school_id
    add_index :users, [:email, :school_id], :unique => true
    add_index :users, [:username, :school_id], :unique => true
  end
end
