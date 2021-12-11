class Post < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :topic
  belongs_to :parent, optional: true, class_name: "Post"
  has_many :replies, class_name: "Post", foreign_key: :parent_id, dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, presence: true, length: {maximum: 1000}

  after_create_commit do
    if self.parent_id == 0
      broadcast_append_to "posts"
    else 
      broadcast_append_to [self.parent, :replies], target: "#{dom_id(self.parent)}_replies"
    end
  end

  after_update_commit do
    broadcast_replace_to self
  end

  after_destroy_commit do
    broadcast_remove_to self
  end

  def mark_for_delete
    self.update(deleted_at: Time.current) if self.deleted_at.nil?
  end

end
