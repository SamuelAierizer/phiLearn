class AssignmentPolicy < ApplicationPolicy
  attr_reader :user, :assignment

  def initialize(user, assignment)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @assignment = assignment
  end

  def index?
    teacher_rights
  end

  def show?
    (assignment.hasUser(user) || admin_rights) && assignment.deleted_at.nil?
  end

  def create?
    teacher_rights 
  end

  def new?
    create?
  end

  def update?
    admin_rights || assignment.hasAsTeacher(user)
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
