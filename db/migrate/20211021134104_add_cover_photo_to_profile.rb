class AddCoverPhotoToProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :cover_photo, :string
  end
end
