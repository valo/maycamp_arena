class Run < ActiveRecord::Base
  module Constants
    LANG_C_CPP = "C/C++"
    LANG_PAS = "Pascal"

    LANGUAGES = [LANG_C_CPP]
    WAITING = "waiting"
    JUDGING = "judging"
    CHECKING = "checking"
  end

  include Constants

  belongs_to :user
  belongs_to :problem

  validates_inclusion_of :language, :in => LANGUAGES
  validates_presence_of :user, :problem, :language, :source_code

  scope :during_contest, -> { joins(:problem => :contest).where("runs.created_at > contests.start_time").where("runs.created_at < contests.end_time") }

  before_save :update_total_points, :update_time_and_mem
  has_one :run_blob_collection, :dependent => :destroy

  def self.languages
    LANGUAGES
  end

  def points
    points_float.map { |pts| pts.is_a?(BigDecimal) ? pts.round(0).to_i : pts }
  end

  # Converting the total points to integer. This is what it is most of the time.
  def total_points
    self.read_attribute(:total_points).to_i
  end

  def source_file=(file)
    self.source_code = file.read
  end

  def source_code=(content)
    self.build_run_blob_collection if self.run_blob_collection.nil?
    self.run_blob_collection.source_code = content
  end

  def source_code
    self.run_blob_collection.try(:source_code)
  end

  def log=(content)
    self.build_run_blob_collection if self.run_blob_collection.nil?
    self.run_blob_collection.log = content
  end

  def log
    self.run_blob_collection.try(:log)
  end

  def total_points_float
    points_float.sum { |test| test.is_a?(BigDecimal) ? test : 0 }
  end

  def points_float
    total_tests = status.split(/\s+/).length
    status.split(/\s+/).map { |out| out == "ok" ? (BigDecimal("100") / total_tests) : out }
  end

  def update_total_points
    self.total_points = points_float.sum { |test| test.is_a?(BigDecimal) ? test : 0 }.round.to_i
  end

  def update_time_and_mem
    if self.log
      max_time = self.log.scan(/Used time: ([0-9\.]+)/).map { |t| BigDecimal.new(t.first) }.max
      max_memory = self.log.scan(/Used mem: ([0-9]+)/).map(&:first).map(&:to_i).max

      self.max_time = max_time
      self.max_memory = max_memory
    end
  end
end
