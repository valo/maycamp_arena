class RecalculateUserLevelInfo < ActiveRecord::Migration
  def up
    User.find_each do |user|
      IncreaseExpForUserJob.perform_later(user.id, user_exp(user).to_i)
    end
  end

  def down
    LevelInfo.destroy_all
  end

  private

  def user_exp(user)
    total_points(user) / 100 * IncreaseExpForUser::DEFAULT_PROBLEM_EXP
  end

  def total_points(user)
    user.runs.select('MAX(total_points) as max_points').group(:problem_id).to_a.sum(&:max_points).to_f
  end
end
