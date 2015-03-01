class AdminStatusPolicy < ApplicationPolicy
  def show?
    user && user.admin?
  end
end
