require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login

  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  
  validates_presence_of     :unencrypted_password, :on => :create
  validates_confirmation_of :unencrypted_password, :on => :create
  
  attr_accessor :unencrypted_password
  attr_protected :unencrypted_password, :unencrypted_password_confirmation, :admin

  has_many :contest_start_events, :dependent => :destroy
  has_many :runs, :dependent => :destroy, :select => (Run.column_names - ["log", "source_code"]).join(",")
  has_many :runs_with_log, :class_name => 'Run'

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    user = find_by_login(login.downcase) # need to get the salt
    
    if user and user.password == encrypt_password(password)
      return user
    end
    
    nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def best_practice_score(contest)
    Run.send :with_scope, :find => {:conditions => { :user_id => self.id } } do
      contest.problems.map do |problem|
        # Find the max run for each problem
        problem.runs.map(&:total_points).max
      end.compact.sum
    end
  end
  
  def unencrypted_password=(value)
    @unencrypted_password = value
    write_attribute(:password, self.class.encrypt_password(value))
  end
  
  private
    def self.encrypt_password(password)
      return nil unless password
      Digest::SHA1.hexdigest(password)
    end
end
