require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login

  validates_length_of       :name,     :maximum => 100
  validates_presence_of     :name

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  
  validates_presence_of     :unencrypted_password, :on => :create
  validates_confirmation_of :unencrypted_password
  
  validates_presence_of :city
  
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
  
  def full_tasks
    Run.count('problem_id', :conditions => { :user_id => self.id, :total_points => 100 }, :distinct => true)
  end
  
  def unencrypted_password=(value)
    @unencrypted_password = value
    write_attribute(:password, self.class.encrypt_password(value))
  end
  
  def reset_token!
    self.token = (1..16).to_a.map { (('0'..'9').to_a + ('a'..'z').to_a).rand }.join
    self.save!
  end
  
  def total_points
    query = %Q{SELECT 
                  users.id, 
                  name, 
                  admin, 
                  SUM(max_points_per_problem) as score, 
                  SUM(CASE WHEN max_points_per_problem IS NULL THEN 0 ELSE runs_per_problem END) as runs_count,
                  SUM(CASE max_points_per_problem WHEN 100 THEN 1 ELSE 0 END) as full_solutions
               FROM users
               LEFT JOIN
                (
                  SELECT
                    MAX(total_points) as max_points_per_problem,
                    user_id,
                    COUNT(runs.id) as runs_per_problem
                  FROM runs
                  JOIN problems ON problems.id = problem_id
                  JOIN contests ON contests.id = problems.contest_id
                  WHERE contests.results_visible = TRUE
                  GROUP BY user_id, problem_id
                ) as problem_points
              ON problem_points.user_id = users.id
              WHERE users.id = #{self.id}
      }
      User.connection.select_one(query)["score"].to_i
  end
  
  class << self
    def generate_ranklist(options = {})
      query = %Q{SELECT 
                    users.id, 
                    name, 
                    admin, 
                    SUM(max_points_per_problem) as score, 
                    SUM(CASE WHEN max_points_per_problem IS NULL THEN 0 ELSE runs_per_problem END) as runs_count,
                    SUM(CASE max_points_per_problem WHEN 100 THEN 1 ELSE 0 END) as full_solutions
                 FROM users
                 LEFT JOIN
                  (
                    SELECT
                      MAX(total_points) as max_points_per_problem,
                      user_id,
                      COUNT(runs.id) as runs_per_problem
                    FROM runs
                    JOIN problems ON problems.id = problem_id
                    JOIN contests ON contests.id = problems.contest_id
                    WHERE contests.results_visible = TRUE
                    GROUP BY user_id, problem_id
                  ) as problem_points
                ON problem_points.user_id = users.id
                WHERE
                  admin = FALSE
                GROUP BY users.id
                ORDER BY score DESC, full_solutions DESC, runs_count ASC, name ASC
        }
      query += " LIMIT #{options[:limit]}" if options[:limit]
      
      User.connection.select_all(query).inject([]) do |ranklist, row|
        ranklist << [User.send(:instantiate, row), row['score'], row['runs_count'], row['full_solutions']]
      end
    end
  end
  
  private
    def self.encrypt_password(password)
      return nil unless password
      Digest::SHA1.hexdigest(password)
    end
end