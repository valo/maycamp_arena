class UpdateProblemBestScoresJob < ActiveJob::Base
  queue_as :leveling

  def perform(user_id)
    UpdateProblemBestScores.new(User.find(user_id)).call
  end
end
