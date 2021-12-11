class Question < ApplicationRecord
  belongs_to :assignment, :optional => true
  has_many :question_options, dependent: :destroy
  has_many :answers, dependent: :destroy
  
  validates :question_asked, :mark_available, presence: true
  
  accepts_nested_attributes_for :question_options, allow_destroy: true, reject_if: :all_blank

  enum question_type: {radial: 1, checkbox: 2, open: 3}

  def isOwner(user)
    self.assignments.course.isOwner(user)
  end

end
