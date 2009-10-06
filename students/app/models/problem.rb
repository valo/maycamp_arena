class Problem < ActiveRecord::Base
  has_many :runs
  belongs_to :contest
  
  validates_presence_of :name, :time_limit, :about
  validates_numericality_of :time_limit, :memory_limit
  
  def tests_dir
    File.join(contest.root_dir, filesystem_name)
  end
  
  def input_files
    Dir[File.join(tests_dir, "*.in*")].sort
  end
  
  def output_files
    Dir[File.join(tests_dir, "*.ans*")].sort
  end
  
  def other_files
    (Dir[File.join(tests_dir, "*")].select { |f| File.file?(f) } - input_files - output_files).sort
  end
  
  def all_files
    (input_files + output_files + other_files).sort
  end
  
  def number_of_tests
    input_files.count
  end
  
  def text_memory_limit
    "%s MB" % (memory_limit / (1024 * 1024)).round
  end
  
  def filesystem_name
    id.to_s
  end
end
