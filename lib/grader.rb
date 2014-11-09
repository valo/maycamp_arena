require "shell_utils"
require "sets_sync"

class Grader
  def initialize
    @tests_updated_at = SyncTests.new(Time.now).call
  end
  
  def run
    running = true
    puts "Ready to grade"
    
    while running do
      ["INT", "TERM"].each do |signal|
        Signal.trap(signal) do
          puts "Stopping..."
          running = false
        end
      end
      
      @tests_updated_at = SyncTests.new(@tests_updated_at).call
      
      if run = Run.where(:status => Run::WAITING).order("runs.created_at ASC").first
        GradeRun.new(run).call
      elsif run = Run.where(:status => Run::CHECKING).order("runs.created_at ASC").first
        GradeRun.new(run, 1)
      else
        sleep 1
      end
    end
  end

  def benchmark(samples = 100)
    @tests_updated_at = SyncTests.new(@tests_updated_at).call
    
    total_runs = 0
    total_factors = 0
    
    total_factor = Run.where(:total_points => 100).where("max_time > 0").order("RAND()").limit(samples).each do |run|
      original_time = run.max_time
      original_points = run.total_points

      grade(run, nil, true)

      run.update_time_and_mem
      run.update_total_points
      
      next if original_points != run.total_points
      
      total_factors += original_time / run.max_time
      total_runs += 1
    end
    
    puts "The bech factor of the machine is #{total_factors / total_runs}"
  end

  private
    attr_reader :tests_updated_at
end
