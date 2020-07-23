require 'latinize'

class Problem < ActiveRecord::Base
  include Latinize

  has_many :runs, :dependent => :destroy
  belongs_to :contest
  has_and_belongs_to_many :categories
  has_one :problem_stats, dependent: :destroy

  has_many_attached :assets

  validates_presence_of :name, :time_limit
  validates_numericality_of :time_limit, :memory_limit, :greater_than => 0

  latinize :name

  def tests_dir
    File.join(contest.root_dir, filesystem_name)
  end

  def input_files
    Dir[File.join(tests_dir, "*.in*")].sort
  end

  def output_files
    Dir[File.join(tests_dir, "*.{ans,sol}*")].sort
  end

  def other_files
    (Dir[File.join(tests_dir, "*")].select { |f| File.file?(f) } - input_files - output_files).sort
  end

  def all_files
    (input_files + output_files + other_files).sort
  end

  def checker
    checker_file = other_files.detect { |file| file =~ /checker$/ }
    if checker_file and File.exist?(checker_file)
      # Make the checker excutable
      File.chmod 0755, checker_file
      return checker_file
    end

    nil
  end

  def checker_source
    other_files.detect { |file| file =~ /checker.*c(pp)?$/ }
  end

  def number_of_tests
    input_files.length
  end

  def text_memory_limit
    if memory_limit < 1024
      "%s bytes" % memory_limit
    elsif memory_limit < 1024 * 1024
      "%s KB" % (memory_limit / 1024).round
    else
      "%s MB" % (memory_limit / (1024 * 1024)).round
    end
  end

  def filesystem_name
    id.to_s
  end

end
