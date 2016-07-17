class IncreaseExpForUser
  DEFAULT_PROBLEM_EXP = 500

  def initialize(user, gained_exp)
    @user = user
    @gained_exp = gained_exp
  end

  def call
    User.transaction do
      level_info.increment(:current_exp, gained_exp)

      level_up if level_info.current_exp >= next_level_exp

      level_info.save!
    end
  end

  private

  attr_reader :user, :gained_exp

  def level_up
    next_level_overflow = level_info.current_exp - next_level_exp

    level_info.update!(
      level: level_info.level + 1,
      current_exp: 0,
      last_level_showed_at: nil
    )

    self.class.new(user, next_level_overflow).call
  end

  def level_info
    user.build_level_info unless user.level_info
    user.level_info
  end

  def next_level_exp
    level_info.level * LevelInfo::BASE_LEVEL_MULTIPLIER
  end
end
