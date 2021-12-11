class CoursePolicy < ApplicationPolicy
  attr_reader :user, :course

  def initialize(user, course)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @course = course
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.where(owner_id: User.where(school_id: @user.school_id).pluck(:id))
      elsif user.teacher?
        scope.where(owner_id: user.id)
      else
        scope.none
      end
    end
  end

  def index?
    teacher_rights
  end

  def stats?
    index?
  end

  def show?
    (course.hasUser(user) || admin_rights) && course.deleted_at.nil?
  end

  def create?
    teacher_rights
  end

  def new?
    create?
  end

  def update?
    admin_rights || course.hasAsTeacher(user)
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

  def add_users?
    teacher_rights
  end

  def populate?
    teacher_rights
  end

end