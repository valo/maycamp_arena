class RunPolicy < ApplicationPolicy
  def show?
    user_admin? || user_is_coach_and_owns_run?
  end

  def index?
    user_admin? || user_coach?
  end

  def update?
    user_admin?
  end

  def create?
    user_admin?
  end

  def new?
    user_admin?
  end

  def edit?
    user_admin?
  end

  private

  def user_is_coach_and_owns_run?
    user_coach? && user.id == record.user_id
  end

  def user_admin?
    user && user.admin?
  end

  def user_coach?
    user && user.coach?
  end
end
