class ProblemPolicy < ApplicationPolicy
  def toggle_runs_visible?
    user && user.admin?
  end
end
