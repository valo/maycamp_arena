require 'grader'

namespace :grader do
  desc "Start the grader"
  task :start => :environment do
    Grader.new.run
  end

  desc "Start the grader without sync"
  task :start_nosync => :environment do
    Grader.new(false).run
  end

  desc "Syncronize the local tests with the remote tests"
  task :sync => :environment do
    grader_conf = get_config
    SetsSync.sync_sets(grader_conf)
  end
  
  task :benchmark => :environment do
    grader_conf = get_config
    Grader.new.benchmark
  end
  
  task :grade_run, [:run_id] => [:environment] do |t, args|
    grader_conf = get_config
    run = Run.find(args[:run_id])
    GradeRun.new(run, nil, true).call
    run.update_time_and_mem
    run.update_total_points
    
    puts "Result: #{run.status}"
    puts "Max time: #{run.max_time}"
    puts "Max memory: #{run.max_memory}"
    puts "Log:"
    puts run.log
  end
end
