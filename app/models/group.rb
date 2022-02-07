class Group < ApplicationRecord
  has_many :group_posts, :dependent => :destroy
  has_many :members, as: :memable, :dependent => :destroy

  validates :name, :group_type, :created_by, presence: true

  enum group_type: {Interest: 1, Study: 2, Club: 3, Hobby: 4, Faculty: 5, Learners: 6, Topic: 7, Translators: 8}

  def hasMember(user)
    self.members.exists?(uid: user.id)
  end

  def hasAdmin(user)
    self.members.exists?(uid: user.id, mem_type: 'admin')
  end

end
