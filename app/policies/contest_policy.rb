class ContestPolicy < ApplicationPolicy
  def index?
    admin_or_coach?
  end

  def new?
    admin_or_coach?
  end

  def create?
    admin_or_coach?
  end

  def edit?
    admin_or_coach?
  end

  def update?
    admin_or_coach?
  end

  def destroy?
    admin_or_coach?
  end

  def show?
    admin_or_coach?
  end

  def download_sources?
    user && user.admin?
  end

  def toggle_runs_visible?
    user && user.admin?
  end

  private

  def admin_or_coach?
    user && (user.admin? || user.coach?)
  end

end
