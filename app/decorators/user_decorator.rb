class UserDecorator < Draper::Decorator
  delegate_all

  def avatar_image_path
    "icons/level_#{ avatar_icon_level }.png"
  end

  def avatar_overlays
    case user.level_info.level % 3
    when 2
      ['icons/badge.png']
    when 0
      ['icons/crown.png']
    else
      []
    end
  end

  private

  def avatar_icon_level
    level = (user.level_info.level / 3).to_i * 3 + 1
    level -= 3 if user.level_info.level % 3 == 0
    level
  end
end
