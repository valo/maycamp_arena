# -*- encoding : utf-8 -*-
require 'latinize'

class Contest < ActiveRecord::Base
  include Latinize

  RUNNER_TYPES = ["fork", "box"]

  has_many :problems, :dependent => :destroy
  has_many :runs, :through => :problems
  has_many :contest_start_events, :dependent => :destroy
  has_many :contest_results
  belongs_to :group

  scope :upcoming, -> { where('? < start_time', Time.now.utc) }
  scope :current, -> { where('? > start_time AND ? < end_time', Time.now.utc, Time.now.utc) }
  scope :finished, -> { where('? > end_time', Time.now.utc) }
  scope :practicable, -> { where(:practicable => true) }
  scope :visible, -> { where(:visible => true) }

  validates_presence_of :name, :duration, :start_time, :end_time
  validates_numericality_of :duration

  validates_inclusion_of :runner_type, :in => RUNNER_TYPES

  before_validation :generate_code

  latinize :name

  def root_dir
    File.join($config[:sets_root], id.to_s)
  end

  def finished?
    Time.now > end_time
  end

  def current?
    Time.now > start_time && Time.now < end_time
  end

  # True if the user is allowed to submit solutions for this competition
  def allow_user_submit(user)
    current? and !expired_for_user(user)
  end

  def user_open_time(user)
    user.contest_start_events.find_by_contest_id(id).andand.created_at
  end

  def expired_for_user(user)
    finished? or (user_open_time(user) and user_open_time(user) + duration.minutes < Time.now)
  end

  def max_score
    100 * problems.count
  end

  def generate_contest_results
    @results ||= GenerateContestResults.new(self).call
  end

  private
    def generate_code
      self.set_code = name.underscore
    end
end
