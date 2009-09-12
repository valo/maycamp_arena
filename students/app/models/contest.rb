class Contest < ActiveRecord::Base
  has_many :problems
  has_many :runs, :through => :problems
  has_many :contest_start_events
  
  named_scope :current, :conditions => ['? > start_time AND ? < end_time', Time.now.to_s(:db), Time.now.to_s(:db)]
  named_scope :finished, :conditions => ['? > end_time', Time.now.to_s(:db)]
  
  validates_presence_of :name, :duration, :start_time, :about
  validates_numericality_of :duration
  
  before_validation :generate_code
  
  def root_dir
    File.join($config[:sets_root], set_code)
  end
  
  def expired?
    Time.now > end_time
  end
  
  # True if the user is allowed to submit solutions for this competition
  def allow_user_submit(user)
    Time.now > start_time or user_open_time(user).nil? or Time.now < user_open_time(user) + duration.minutes
  end
  
  def user_open_time(user)
    user.contest_start_events.find_by_contest_id(id).andand.created_at
  end
  
  def expired_for_user(user)
    !expired? and user_open_time(user) + duration.minutes > Time.now
  end
  
  private
    def generate_code
      self.set_code = name.underscore
    end
end
