class Contest < ActiveRecord::Base
  has_many :problems
  has_many :runs, :through => :problems, :order => :created_at
  has_many :contest_start_events
  
  named_scope :current, :conditions => ['? > start_time AND ? < end_time', Time.now.utc, Time.now.utc]
  named_scope :finished, :conditions => ['? > end_time', Time.now.utc]
  named_scope :practicable, :conditions => { :practicable => true }
  
  validates_presence_of :name, :duration, :start_time, :about
  validates_numericality_of :duration
  
  before_validation :generate_code
  
  def root_dir
    File.join($config[:sets_root], id)
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
    !finished? and !user_open_time(user).nil? and user_open_time(user) + duration.minutes < Time.now
  end
  
  def max_score
    100 * problems.count
  end
  
  private
    def generate_code
      self.set_code = name.underscore
    end
end
