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
      
      puts "Users found #{user_list.map(&:name).join(', ')}"
      if user_list.length == 1
        contest_result.user = user_list.first
        next
      end
      
      # Try to match the name with the names from the arena
      user_list = User.all(:conditions => ["city = ? OR city IS NULL ", contest_result.city ])
      
      user_list.each do |user|
        user_name_parts = user.name.split.map { |str| str.mb_chars.downcase.wrapped_string }
        result_name_parts = contest_result.coder_name.split.map { |str| str.mb_chars.downcase.wrapped_string }
        
        score = 0
        
        score += 1 if user_name_parts.first == result_name_parts.first
        score += 1 if user_name_parts.last == result_name_parts.last and user_name_parts.length > 1
        
        # If there are at least 2 matching names this is a match
        if score >= 2
          # match!
          contest_result.user = user
          break
        end
      end
    end
  end
end
