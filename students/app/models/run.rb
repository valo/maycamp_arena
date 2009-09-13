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
  
  def points
    points_float.map { |pts| pts.is_a?(BigDecimal) ? pts.round(0).to_i : pts }
  end
  
  def points_float
    total_tests = status.split(/\s+/).count
    status.split(/\s+/).map { |out| out == "ok" ? (BigDecimal("100") / total_tests) : out }
  end
  
  def total_points
    points_float.sum { |test| test.is_a?(BigDecimal) ? test : 0 }.round.to_i
  end
end
