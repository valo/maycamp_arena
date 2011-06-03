begin
  require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
  require 'grader'
  require 'shell_utils'

  namespace :grader do
    include ShellUtils
  
    desc "Start the grader"
    task :start do
      grader_conf = get_config
      Grader.new(grader_conf["root"], grader_conf["user"]).run
    end
  
    desc "Start the grader without sync"
    task :start_nosync do
      grader_conf = get_config
      Grader.new(grader_conf["root"], grader_conf["user"]).run
    end
  
    desc "Syncronize the local tests with the remote tests"
    task :sync do
      grader_conf = get_config
      SetsSync.sync_sets(grader_conf)
    end
  end
rescue Exception
  puts "Cannot load the grader tasks. Exception: #{$!.inspect}"
end