class Contest < ActiveRecord::Base
  has_many :problems
  has_many :runs, :through => :problems
  
  named_scope :current, :conditions => ['UNIX_TIMESTAMP(start_time) < UNIX_TIMESTAMP(?) AND (UNIX_TIMESTAMP(start_time) + 60 * duration) > UNIX_TIMESTAMP(?)', Time.now.to_s(:db), Time.now.to_s(:db)]
  named_scope :finished, :conditions => ['(UNIX_TIMESTAMP(start_time) + 60 * duration) < UNIX_TIMESTAMP(?)', Time.now.to_s(:db)]
end
