class FixUsersWithoutLevelInfo < ActiveRecord::Migration
  def up
    User.includes(:level_info).find_each do |user|
      next if user.level_info

      say "Fixing user #{ user.id }"
      IncreaseExpForUser.new(user, 0).call
    end
  end
end
