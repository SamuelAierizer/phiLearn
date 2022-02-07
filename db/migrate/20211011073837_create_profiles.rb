class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.text :about
      t.string :address
      t.string :phone
      t.integer :status
      t.string :public_src
      t.integer :user_id

      t.timestamps
    end
    add_index :profiles, :user_id, unique: true
  end
end
