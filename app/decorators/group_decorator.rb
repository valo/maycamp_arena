class GroupDecorator < Draper::Decorator
  delegate_all

  decorates_association :contests

  def best_practice_score
    contests.sum(&:best_practice_score)
  end

  def practice_score_percent
    return 0 if contests.length == 0
    contests.sum(&:practice_score_percent) / contests.length
  end

  def max_score
    contests.sum(&:max_score)
  end
end
