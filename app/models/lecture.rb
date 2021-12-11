class Lecture < ApplicationRecord
  belongs_to :course, :optional => true
  has_many :comments, as: :target, :dependent => :destroy
  has_many :resources, as: :material, :dependent => :destroy

  
  validates :name, :description, presence: true
  validates :description, length: {maximum: 1000}

  def hasUser(user)
    self.course.hasUser(user)
  end

  def hasAsTeacher(user)
    self.course.hasAsTeacher(user)
  end

end
