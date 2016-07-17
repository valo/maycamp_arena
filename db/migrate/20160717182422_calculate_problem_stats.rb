class CalculateProblemStats < ActiveRecord::Migration
  def up
    Problem.find_each do |problem|
      CalculateProblemStatsJob.perform_later(problem.id)
    end
  end

  def down
    ProblemStats.delete_all
  end
end
