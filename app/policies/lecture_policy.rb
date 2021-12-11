class LecturePolicy < ApplicationPolicy
  attr_reader :user, :lecture

  def initialize(user, lecture)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @lecture = lecture
  end

  def index?
    teacher_rights
  end

  def show?
    (lecture.hasUser(user) || admin_rights) && lecture.deleted_at.nil?
  end

  def create?
    teacher_rights 
  end

  def new?
    create?
  end

  def update?
    admin_rights || lecture.hasAsTeacher(user)
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
