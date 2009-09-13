module MainHelper
  def duration_in_words(duration)
    hours = (duration / 1.hour).to_i
    minutes = ((duration % 1.hours) / 1.minute).to_i
    
    result = ""
    if hours == 1
      result += "1 час"
    elsif hours > 1
      result += "#{hours} часа"
    end

    if minutes == 1
      result += " 1 минута"
    elsif minutes > 1
      result += " #{minutes} минути"
    end
    
    result
  end
end