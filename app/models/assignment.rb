class Assignment < ApplicationRecord
  include Paginatable

  has_rich_text :description
  has_many_attached :files


  belongs_to :course, :optional => true
  has_many :questions, :dependent => :destroy
  has_many :solutions, :dependent => :destroy
  has_many :comments, as: :target, :dependent => :destroy
  has_and_belongs_to_many :users

  validates :name, :description, presence: true
  validates :description, length: {maximum: 1000}

  enum assignment_type: {handIn: 0, quiz: 1}

  def hasUser(user)
    self.course.hasUser(user)
  end

  def hasAsTeacher(user)
    self.course.hasAsTeacher(user)
  end

  def userSolution(user)
    Solution.where(assignment_id: self.id, user_id: user).first
  end
end
