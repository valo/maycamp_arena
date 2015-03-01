class CategoryPolicy < ApplicationPolicy
  def show?
    user && (user.admin? || user.coach?)
  end
end
