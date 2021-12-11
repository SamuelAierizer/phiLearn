class QuestionPolicy < ApplicationPolicy
  attr_reader :user, :question

  def initialize(user, question)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = question
  end

  def index?
    admin_rights
  end

  def show?
    teacher_rights
  end

  def create?
    teacher_rights
  end

  def new?
    create?
  end

  def update?
    teacher_rights
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
