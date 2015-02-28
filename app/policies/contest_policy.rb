class ContestPolicy < ApplicationPolicy
  def index?
    user && (user.admin? || user.coach?)
  end
end
