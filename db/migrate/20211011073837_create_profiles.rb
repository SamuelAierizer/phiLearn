class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.text :about, :default => 'about me text'
      t.string :address, :default => 'address'
      t.string :phone, :default => 'phone no.'
      t.integer :status, :default => 'active'
      t.string :public_src
      t.integer :user_id

      t.timestamps
    end
    add_index :profiles, :user_id, unique: true
  end
end
