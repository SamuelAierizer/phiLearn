class Topic < ApplicationRecord
  belongs_to :forum
  has_many :posts, :dependent => :destroy

  has_many :likes, as: :likeable, :dependent => :destroy

  validates :name, :description, presence: true
  validates :description, length: {maximum: 1000}

  after_create_commit { broadcast_append_to "topics" }
  after_update_commit { broadcast_replace_to "topics" }
  after_destroy_commit { broadcast_remove_to "topics" }

  def mark_for_delete
    self.update(deleted_at: Time.current) if self.deleted_at.nil?
  end
end
