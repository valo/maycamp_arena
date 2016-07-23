class GradeRunJob < ActiveJob::Base
  queue_as :grader

  def perform(run_id, tests=nil)
    GradeRun.new(Run.find(run_id), tests).call
  end
end
