class Profile < ApplicationRecord
  belongs_to :user

  has_rich_text :about
  has_one_attached :cover_photo

  enum status: {inactive: 0, active: 1, blocked: 2}
end