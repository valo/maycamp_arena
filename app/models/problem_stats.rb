class ProblemStats < ActiveRecord::Base
  MAX_RANK = 8388607

  belongs_to :problem

  def success_rank
    return MAX_RANK if percent_success.zero?
    ProblemStats.where('percent_success > ?', percent_success).count + 1
  end
end
