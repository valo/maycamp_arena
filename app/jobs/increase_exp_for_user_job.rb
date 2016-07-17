class IncreaseExpForUserJob < ActiveJob::Base
  queue_as :leveling

  def perform(user_id, gained_exp)
    IncreaseExpForUser.new(User.find(user_id), gained_exp).call
  end
end
