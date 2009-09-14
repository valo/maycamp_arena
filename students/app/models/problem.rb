class Problem < ActiveRecord::Base
  has_many :runs
  belongs_to :contest
  
  validates_presence_of :name, :time_limit, :about
  validates_numericality_of :time_limit
  
  def tests_dir
    File.join(contest.root_dir, filesystem_name)
  end
  
  def input_files
    Dir[File.join(tests_dir, "*.in*")]
  end
  
  def output_files
    Dir[File.join(tests_dir, "*.ans*")]
  end
  
  def other_files
    Dir[File.join(tests_dir, "*")].select { |f| File.file?(f) } - input_files - output_files
  end
  
  def all_files
    input_files + output_files + other_files
  end
  
  def filesystem_name
    id
  end
end
