class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :target, polymorphic: true
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy


  validates :body, presence: true

  enum target_type: {'Course': 1, 'Lecture': 2, 'Assignment': 3, 'GroupPost': 4}

  def owner(user)
    self.user.id == user.id
  end
end
