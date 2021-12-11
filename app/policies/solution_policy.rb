class SolutionPolicy < ApplicationPolicy
  attr_reader :user, :solution

  def initialize(user, solution)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @solution = solution
  end

  def index?
    teacher_rights
  end

  def show?
    (teacher_rights || solution.owner(user)) && solution.deleted_at.nil?
  end

  def update?
    admin_rights || solution.hasAsTeacher(user)
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def mass_delete?
    teacher_rights
  end

end
