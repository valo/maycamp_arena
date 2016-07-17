class CalculateProblemStats
  def initialize(problem)
    @problem = problem
  end

  def call
    problem_stats.update!(percent_success: percent_success)
  end

  private

  attr_reader :problem

  def problem_stats
    problem.build_problem_stats unless problem.problem_stats
    problem.problem_stats
  end

  def percent_success
    return 0 if runs.length.zero?
    runs.to_a.sum(&:max_points) * 1.0 / runs.length
  end

  def runs
    @runs ||= problem
      .runs
      .select('MAX(total_points) AS max_points')
      .group(:user_id)
  end
end
