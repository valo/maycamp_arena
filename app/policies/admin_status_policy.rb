class AdminStatusPolicy < ApplicationPolicy
  def show?
    user && (user.admin? || user.coach?)
  end
end
