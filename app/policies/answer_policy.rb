class AnswerPolicy < ApplicationPolicy
  attr_reader :user, :answer

  def initialize(user, answer)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @answer = answer
  end

  def index?
    false
  end

  def show?
    false
  end

  def update?
    admin_rights || answer.hasAsTeacher(user)
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
