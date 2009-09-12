class Run < ActiveRecord::Base
  LANGUAGES = ["C/C++"]
  WAITING = "waiting"
  
  belongs_to :user
  belongs_to :problem
  
  validates_inclusion_of :language, :in => LANGUAGES
  validates_presence_of :user, :problem, :language, :source_code
  
  def self.languages
    LANGUAGES
  end
end
