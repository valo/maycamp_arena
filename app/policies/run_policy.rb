class RunPolicy < ApplicationPolicy
  def show?
    user_admin? || user_is_coach_and_owns_run? || problem_is_visible?
  end    

  def index?
    user_admin? || user_coach?
  end

  def update?
    user_admin?
  end

  def create?
    user_admin? || user_coach?
  end

  def new?
    user_admin? || user_coach?
  end

  def edit?
    user_admin?
  end

  def queue?
    user_admin? || user_coach?
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

  def problem_is_visible?
    record.problem.runs_visible
  end

end
