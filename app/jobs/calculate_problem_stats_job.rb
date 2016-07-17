class CalculateProblemStatsJob < ActiveJob::Base
  queue_as :default

  def perform(problem_id)
    CalculateProblemStats.new(Problem.find(problem_id)).call
  end
end
