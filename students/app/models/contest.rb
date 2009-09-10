class Contest < ActiveRecord::Base
  has_many :problems
  has_many :runs, :through => :problems
  
  named_scope :current, :conditions => ['UNIX_TIMESTAMP(start_time) < UNIX_TIMESTAMP(?) AND (UNIX_TIMESTAMP(start_time) + 60 * duration) > UNIX_TIMESTAMP(?)', Time.now.to_s(:db), Time.now.to_s(:db)]
  named_scope :finished, :conditions => ['(UNIX_TIMESTAMP(start_time) + 60 * duration) < UNIX_TIMESTAMP(?)', Time.now.to_s(:db)]
  
  validates_presence_of :name, :duration, :start_time, :about
  validates_numericality_of :duration
  
  before_validation :generate_code
  
  def root_dir
    File.join($config[:sets_root], set_code)
  end
  
  private
    def generate_code
      self.set_code = name.underscore
    end
end
