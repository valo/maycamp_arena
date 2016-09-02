class UpdateProblemBestScores
  def initialize(user)
    @user = user
  end

  def call
    ProblemBestScore.transaction do
      new_best_scores.each do |best_score|
        current_best_scores[best_score.problem_id] ||= build_best_score(best_score)
        update_best_score(current_best_scores[best_score.problem_id], best_score)
      end
    end
  end

  private

  attr_reader :user

  def new_best_scores
    user.runs.select('MAX(total_points) as max_points', 'problem_id').group(:problem_id)
  end

  def current_best_scores
    @current_best_scores ||= Hash[user.problem_best_scores.map { |best_score| [best_score.problem_id, best_score] }]
  end

  def build_best_score(best_score)
    ProblemBestScore.new(
      user_id: user.id,
      problem_id: best_score.problem_id,
      top_points: 0
    )
  end

  def update_best_score(current_best_score, new_best_score)
    if current_best_score.top_points < new_best_score.max_points
      score_increase = new_best_score.max_points - current_best_score.top_points
      IncreaseExpForUser.new(
        user,
        (score_increase * IncreaseExpForUser::DEFAULT_PROBLEM_EXP / 100.0).to_i
      ).call
    end

    current_best_score.update!(top_points: new_best_score.max_points)
  end
end
