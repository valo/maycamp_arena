module MainHelper
  def duration_in_words(duration)
    hours = (duration / 1.hour).to_i
    minutes = ((duration % 1.hours) / 1.minute).to_i
    
    (hours > 0 ? pluralize(hours, "hours") + " " : "") + (minutes > 0 ? pluralize(minutes, "minutes") : "")
  end
end