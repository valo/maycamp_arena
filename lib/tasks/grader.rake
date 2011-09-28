begin
  require 'grader'
  require 'shell_utils'

  namespace :grader do
    include ShellUtils
  
    desc "Start the grader"
    task :start => :environment do
      grader_conf = get_config
      Grader.new(grader_conf["root"], grader_conf["user"]).run
    end
  
    desc "Start the grader without sync"
    task :start_nosync => :environment do
      grader_conf = get_config
      Grader.new(grader_conf["root"], grader_conf["user"]).run
    end
  
    desc "Syncronize the local tests with the remote tests"
    task :sync => :environment do
      grader_conf = get_config
      SetsSync.sync_sets(grader_conf)
    end
    
    task :benchmark => :environment do
      grader_conf = get_config
      Grader.new(grader_conf["root"], grader_conf["user"]).benchmark
    end
    
    task :grade_run, [:run_id] => [:environment] do |t, args|
      grader_conf = get_config
      run = Run.find(args[:run_id])
      Grader.new(grader_conf["root"], grader_conf["user"]).grade(run, nil, true)
      run.update_time_and_mem
      run.update_total_points
      
      puts "Result: #{run.status}"
      puts "Max time: #{run.max_time}"
      puts "Max memory: #{run.max_memory}"
      puts "Log:"
      puts run.log
    end
  end
rescue Exception
  puts "Cannot load the grader tasks. Exception: #{$!.inspect}"
end