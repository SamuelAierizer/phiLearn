class Answer < ApplicationRecord
  belongs_to :solution, :optional => true
  belongs_to :question, :optional => true

  enum answers_type: {radial: 1, checkbox: 2, open: 3}

  def owner(user)
    self.solution.owner(user)
  end

  def hasAsTeacher(user)
    self.solution.hasAsTeacher(user)
  end

  def compute_mark
    @mark = 0.0
    
    if self.checkbox? && (self.answer_given.include? "[")
      self.answer_given = self.answer_given.tr('\\[],\"', '').strip
    end

    if self.answer_given == self.question.answer
      @mark = self.question.mark_available
    end

    self.update(mark_achieved: @mark)
    return @mark
  end
end
