class ReportPolicy < ApplicationPolicy
  def show?
    user && (user.admin? || user.coach?)
  end
end
