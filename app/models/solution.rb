class Solution < ApplicationRecord
  belongs_to :assignment
  belongs_to :user
  has_many :answers, :dependent => :destroy

  has_one_attached :file

  accepts_nested_attributes_for :answers

  def owner(user)
    self.user.id == user.id
  end

  def hasAsTeacher(user)
    self.assignment.hasAsTeacher(user)
  end

  def calculate_grade
    @marks_available = Question.where(assignment_id: self.assignment_id).sum(:mark_available)
    @marks_achieved = 0.0
    self.answers.each do |answer|
      @marks_achieved += answer.compute_mark
    end

    @newGrade = (@marks_achieved * 10) / @marks_available
    if @newGrade == 0.0 then @newGrade = 1.0 end
    self.update(grade: @newGrade)
    return @newGrade
  end

  def update_grade
    @marks_available = Question.where(assignment_id: self.assignment_id).sum(:mark_available)
    @marks_achieved = 0.0
    self.answers.each do |answer|
      @marks_achieved += answer.mark_achieved
    end

    @newGrade = (@marks_achieved * 10) / @marks_available
    if @newGrade < 1.0 then @newGrade = 1.0 end
    
    self.update(grade: @newGrade)
    return @newGrade
  end
end
