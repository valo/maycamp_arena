class Grader
  def initialize
    @tests_updated_at = SyncTests.new(Time.at(0)).call
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

      sleep 1 unless find_and_grade_run
    end
  end

  def find_and_grade_run
    if run = acquire_run(Run::WAITING)
      GradeRun.new(run).call
    elsif run = acquire_run(Run::CHECKING)
      GradeRun.new(run, 1).call
    else
      false
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

  def acquire_run(status)
    run = Run.where(status: status).order(created_at: :asc).first

    return unless run

    Run.transaction do
      run.lock!
      return nil if run.status != status

      run.update_attribute(:status, Run::JUDGING)

      run
    end
  end
end
