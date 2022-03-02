class Course < ApplicationRecord
  include Paginatable

  has_rich_text :description
  has_one_attached :image
  has_many_attached :files
  

  belongs_to :owner, class_name: 'User', optional: true
  has_many :lectures, :dependent => :destroy
  has_many :assignments, :dependent => :destroy
  has_many :comments, as: :target, :dependent => :destroy
  has_many :resources, as: :material, :dependent => :destroy
  has_many :students
  has_many :users, through: :students
  has_one :forum, as: :forumable, :dependent => :destroy

  
  validates :name, :description, presence: true
  validates :description, length: {maximum: 1000}

  def get_owner
    User.find(self.owner_id).username
  end

  def hasUser(user)
    self.users.exists?(user.id) || hasAsTeacher(user)
  end

  def hasAsTeacher(user)
    self.owner_id == user.id
  end

  def mark_for_delete
    self.update(deleted_at: Time.current) if self.deleted_at.nil?
  end

end
