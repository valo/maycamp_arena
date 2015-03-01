class ExternalContestPolicy < ApplicationPolicy
  def index?
    user && user.admin?
  end
end
