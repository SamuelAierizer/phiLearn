class Member < ApplicationRecord
  belongs_to :memable, polymorphic: true

  enum memable_type: {'Group': 1}
  enum mem_type: {'admin': 1, 'member': 2}
end