require 'latinize'
require 'digest/sha1'

class User < ActiveRecord::Base
  include Latinize

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

  has_many :contest_start_events, dependent: :destroy
  has_many :runs, dependent: :destroy
  has_many :runs_with_log, class_name: 'Run'
  has_many :contest_results
  has_many :problem_best_scores, dependent: :destroy

  has_one :level_info, dependent: :destroy

  latinize :name

  ADMIN = "admin"
  COACH = "coach"
  CONTESTER = "contester"

  ROLES = [
    ADMIN,
    COACH,
    CONTESTER
  ]

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    user = find_by_login(login.downcase) || find_by_email(login.downcase) # need to get the salt

    if user and user.password == encrypt_password(password)
      return user
    end

    nil
  end

  def admin?
    self.role == ADMIN
  end

  def coach?
    self.role == COACH
  end

  def contester?
    self.role == CONTESTER
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def full_tasks
    runs.where(total_points: 100).select(:problem_id).distinct.count
  end

  def full_tasks_list
    throw "Not working yet!"
    Problem.all(:joins => "LEFT JOIN runs ON runs.user_id = #{self.id} AND runs.total_points = 100", :group => "problems.id")
  end

  def unencrypted_password=(value)
    @unencrypted_password = value
    self.password = self.class.encrypt_password(value)
  end

  def reset_token!
    self.token = (1..16).to_a.map { (('0'..'9').to_a + ('a'..'z').to_a).sample }.join
    self.save(validate: false)
  end

  def total_points
    query = %Q{SELECT
                  users.id,
                  users.name,
                  users.role,
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
                    users.name,
                    users.role,
                    users.city,
                    SUM(max_points_per_problem) as score,
                    SUM(CASE WHEN max_points_per_problem IS NULL THEN 0 ELSE runs_per_problem END) as runs_count,
                    MAX(last_run_send_for_problem) as last_run_send,
                    SUM(CASE max_points_per_problem WHEN 100 THEN 1 ELSE 0 END) as full_solutions
                 FROM users
                 LEFT JOIN
                  (
                    SELECT
                      MAX(total_points) as max_points_per_problem,
                      user_id,
                      COUNT(runs.id) as runs_per_problem,
                      MAX(runs.created_at) as last_run_send_for_problem
                    FROM runs
                    JOIN problems ON problems.id = problem_id
                    JOIN contests ON contests.id = problems.contest_id
                    WHERE
                      contests.results_visible = TRUE
                      #{options[:since] ? "AND runs.created_at > '#{options[:since].utc.to_s(:db)}'" : ""}
                    GROUP BY user_id, problem_id
                  ) as problem_points
                ON problem_points.user_id = users.id
                WHERE
                  users.role != '#{ ADMIN }'
                GROUP BY users.id
                HAVING
                  last_run_send > '#{1.year.ago.to_s(:db)}'
                  #{options[:only_active] ? "AND runs_count > 0" : ""}
                ORDER BY score DESC, full_solutions DESC, runs_count ASC, name ASC
        }

      query += " LIMIT #{options[:offset] || 0}, #{options[:limit]}" if options[:limit]

      ranklist = []
      User.connection.select_all(query).inject([]) do |ranklist, row|
        user = User.new(row.except('score', 'runs_count', 'full_solutions', 'last_run_send'))
        ranklist << [user, row['score'], row['runs_count'], row['full_solutions']]
      end
    end
  end

  def participates_in_contests?
    !self.admin? && self.contester?
  end

  private
    def self.encrypt_password(password)
      return nil unless password
      Digest::SHA1.hexdigest(password)
    end
end
