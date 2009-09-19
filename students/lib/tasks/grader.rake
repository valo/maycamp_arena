ARGV.each_with_index do |arg, index|
  RAILS_ENV = ARGV[index + 1] if arg == "-e"
end
RAILS_ENV ||= ENV['RAILS_ENV'] ||= 'development' 
puts "Running in #{RAILS_ENV} environment"

require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
require 'grader'

namespace :grader do
  def get_config
    config = `hostname`.chomp
    grader_conf = YAML.load_file(File.join(RAILS_ROOT, "config/grader.yml"))
    puts "Starting the grader for #{config}"
    if !grader_conf[config]
      puts "Cannot find configuration for #{config}. Check your config/grader.yml"
      exit 1
    end
    grader_conf[config]
  end
  
  desc "Start the grader"
  task :start do
    grader_conf = get_config
    Grader.new(grader_conf["root"], grader_conf["user"], grader_conf["host"]).run
  end
  
  desc "Start the grader without sync"
  task :start_nosync do
    grader_conf = get_config
    Grader.new(grader_conf["root"], grader_conf["user"]).run
  end
end