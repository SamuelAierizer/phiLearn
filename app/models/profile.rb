class Profile < ApplicationRecord
  belongs_to :user

  enum status: {inactive: 0, active: 1, blocked: 2}
end