# -*- encoding : utf-8 -*-
require 'latinize'

class Contest < ActiveRecord::Base
  include Latinize
  extend ActiveSupport::Memoizable
  
  RUNNER_TYPES = ["fork", "box"]
  
  has_many :problems, :dependent => :destroy
  has_many :runs, :through => :problems
  has_many :contest_start_events, :dependent => :destroy
  has_many :contest_results
  has_many :rating_changes, :through => :contest_results
  
  scope :upcoming, lambda { {:conditions => ['? < start_time', Time.now.utc]} }
  scope :current, lambda { {:conditions => ['? > start_time AND ? < end_time', Time.now.utc, Time.now.utc]} }
  scope :finished, lambda { {:conditions => ['? > end_time', Time.now.utc]} }
  scope :practicable, :conditions => { :practicable => true }
  
  validates_presence_of :name, :duration, :start_time
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
    results = []
    self.contest_start_events.find_each(:include => :user) do |event|
      runs = self.runs.during_contest.find(:first, :conditions => { :user_id => event.user_id })
      next if (not event.user.participates_in_contests?) or runs.nil?
      
      total = 0
      
      results << [event.user] + self.problems.map { |problem|
          final_run = final_run_for_problem_and_user_id(problem, event.user_id)

          if final_run
            total += final_run.total_points_float
            final_run.points + [final_run.total_points]
          else
            ["0"] * problem.number_of_tests + ["0"]
          end
      } + [total]
    end
    
    results.sort! { |a,b| b[-1] <=> a[-1] }
    
    # Compute the unique scores and the number people with each score
    diff_scores = results.map { |r| r[-1] }.uniq.map { |score| [score, results.select { |res| res[-1] == score }.length] }
    results.each do |row|
      row.unshift diff_scores.map { |score, number| score > row[-1] ? number : 0 }.sum + 1
    end
  end
  memoize :generate_contest_results
  
  private
    def final_run_for_problem_and_user_id(problem, user_id)
      if self.best_submit_results
        return problem.runs.during_contest.find(:all, :conditions => {:user_id => user_id}).max_by(&:total_points)
      end
      
      problem.runs.during_contest.find(:first, :conditions => {:user_id => user_id}, :order => "runs.created_at DESC")
    end
  
    def generate_code
      self.set_code = name.underscore
    end
end
