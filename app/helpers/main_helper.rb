module MainHelper
  def practice_groups_class
    "hidden" if cookies[:active_practice_button] == "list"
  end

  def practice_list_class
    "hidden" unless cookies[:active_practice_button] == "list"
  end

  def practice_groups_button_class
    "active" unless cookies[:active_practice_button] == "list"
  end

  def practice_list_button_class
    "active" if cookies[:active_practice_button] == "list"
  end
end
