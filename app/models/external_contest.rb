class ExternalContest < ActiveRecord::Base
  has_many :contest_results, :class_name => "ExternalContestResult", :foreign_key => "external_contest_id", :dependent => :destroy
  
  cattr_reader :per_page
  @@per_page = 20
  
  attr_accessor :results
  alias_attribute :end_time, :date
  
  validates_presence_of :name, :date
  
  def results=(res)
    res.each_line do |line|
      name, city, points = line.split("\t")
      contest_result = self.contest_results.build(:coder_name => name, :city => city, :points => points)
    end
    
    match_results_to_users
  end
  
  def match_score
    contest_results.select(&:user).length * 100.0 / contest_results.length
  end
  
  def match_results_to_users
    contest_results.each do |contest_result|
      puts "Processing #{contest_result.coder_name}"
      # Try to find a user from the arena matching this one
      user_list = ExternalContestResult.all(
                    :conditions => [
                        "coder_name = ? AND city = ? AND user_id IS NOT NULL", 
                        contest_result.coder_name, 
                        contest_result.city
                      ],
                    :include => :user).map(&:user).sort! { |a,b| a.id <=> b.id }.uniq
      
      if user_list.length == 1
        contest_result.user = user_list.first
        next
      end
      
      # Try to match the name with the names from the arena
      user_list = User.all(:conditions => ["city = ? OR city IS NULL ", contest_result.city ])
      
      user_list.each do |user|
        # If the score is at least 2 we have a match. Try to latinize the coder
        # name so that if the user has entered his/her name with latin chars we
        # will catch that
        score = [match_names(user.name, contest_result.coder_name),
                 match_names(user.name, latinize(contest_result.coder_name))].max
        if score >= 2
          # match!
          contest_result.user = user
          break
        end
      end
    end
  end
  
  private
    def match_names(name1, name2)
      user_name_parts = name1.split.map { |str| str.mb_chars.downcase.wrapped_string }
      result_name_parts = name2.split.map { |str| str.mb_chars.downcase.wrapped_string }
      
      score = 0
      
      score += 1 if user_name_parts.first == result_name_parts.first
      score += 1 if user_name_parts.last == result_name_parts.last and user_name_parts.length > 1
      
      score
    end
    
    MAP = {
      "а" => "a",
      "б" => "b",
      "в" => "v",
      "г" => "g",
      "д" => "d",
      "е" => "e",
      "ж" => "j",
      "з" => "z",
      "и" => "i",
      "й" => "i",
      "к" => "k",
      "л" => "l",
      "м" => "m",
      "н" => "n",
      "о" => "o",
      "п" => "p",
      "р" => "r",
      "с" => "s",
      "т" => "t",
      "у" => "u",
      "ф" => "f",
      "х" => "h",
      "ц" => "c",
      "ч" => "ch",
      "ш" => "sh",
      "щ" => "sht",
      "ь" => "i",
      "ъ" => "a",
      "ю" => "iu",
      "я" => "ya",
      " " => " "
    }
    def latinize(name)
      result = StringIO.new("")
      unicode_chars = name.mb_chars.downcase
      unicode_chars.length.times do |index|
        result << MAP[unicode_chars[index].wrapped_string]
      end
      
      result.string
    end
end
