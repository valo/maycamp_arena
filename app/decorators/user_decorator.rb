class UserDecorator < Draper::Decorator
  delegate_all

  def avatar_image_path
    "icons/level_#{ avatar_icon_level }.png"
  end

  def avatar_overlays
    case user.level_info.level - avatar_icon_level
    when 2
      ['icons/badge.png']
    when 1
      ['icons/crown.png']
    else
      []
    end
  end

  private

  def avatar_icon_level
    (user.level_info.level / 3).to_i * 3 + 1
  end
end
