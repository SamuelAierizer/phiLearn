class GroupPost < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :group
  belongs_to :user
  has_many :comments, as: :target, :dependent => :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :body, presence: true, length: {maximum: 1000}

  enum post_type: {post: 1, announcement: 2}

  after_create_commit do
    if self.post_type == "post"
      broadcast_prepend_to("group_#{self.group_id}_posts", target: "group_#{self.group_id}_posts", partial: "group_posts/group_post", locals: {group_post: self})
    else 
      broadcast_prepend_to("group_#{self.group_id}_posts", target: "group_#{self.group_id}_posts", partial: "group_posts/group_announcement", locals: {group_announcement: self})
    end
  end

  after_update_commit do
    broadcast_replace_to self
  end

  after_destroy_commit do
    broadcast_remove_to self
  end

end
