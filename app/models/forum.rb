class Forum < ApplicationRecord
  belongs_to :forumable, polymorphic: true
  has_many :topics, :dependent => :destroy

  enum forumable_type: {'School': 1, 'Course': 2}


  def mark_for_delete
    self.update(deleted_at: Time.current) if self.deleted_at.nil?
  end

  def recover
    self.update(deleted_at: nil)
  end
end
