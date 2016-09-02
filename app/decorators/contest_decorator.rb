class ContestDecorator < Draper::Decorator
  delegate_all

  def best_practice_score
    @best_practice_score ||= ProblemBestScore
      .where(user_id: h.current_user.id, problem_id: problems.map(&:id))
      .sum(:top_points)
  end

  def practice_score_percent
    return 0 if max_score.zero?
    best_practice_score * 100.0 / max_score
  end
end
