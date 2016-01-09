class ContestDecorator < Draper::Decorator
  delegate_all

  def best_practice_score
    Run.where(:user_id => h.current_user.id).scoping do
      problems.map do |problem|
        # Find the max run for each problem
        problem.runs.map(&:total_points).max
      end.compact.sum
    end
  end

  def practice_score_percent
    return 0 if max_score.zero?
    best_practice_score * 100.0 / max_score
  end
end
