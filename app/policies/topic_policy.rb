class TopicPolicy < ApplicationPolicy
  attr_reader :user, :topic

  def initialize(user, topic)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @topic = topic
  end

  def create?
    teacher_rights
  end

  def update?
    admin_rights
  end

  def edit?
    update?
  end

  def block?
    admin_rights
  end

  def destroy?
    admin_rights
  end

end