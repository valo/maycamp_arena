class UserPolicy < ApplicationPolicy
  def show?
    admin_user?
  end

  def index?
    admin_user?
  end

  def destroy?
    admin_user?
  end

  def update?
    admin_user?
  end

  def create?
    admin_user?
  end

  def new?
    admin_user?
  end

  def edit?
    admin_user?
  end

  def restart_time?
    admin_user?
  end

  def impersonate?
    admin_user?
  end

  private

  def admin_user?
    user && user.admin?
  end
end
