module MainHelper
  def problem_runs_count(problem)
    Run.all(:include => :user, :conditions => ["NOT users.admin AND problem_id = ?", problem.id]).length
  end

  def problem_runs_total_points(problem)
    Run.all(:include => :user, :conditions => ["NOT users.admin AND problem_id = ?", problem.id]).to_a.sum(&:total_points).to_f
  end
end