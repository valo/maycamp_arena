class UpdateBestScoresOfEveryone < ActiveRecord::Migration
  def up
    # The level info will be recreated by the best score updates
    LevelInfo.delete_all

    User.find_each do |user|
      UpdateProblemBestScoresJob.perform_later(user.id)
    end
  end

  def down
    ProblemBestScore.delete_all
  end
end
