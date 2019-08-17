class Grader
  def initialize(sync=true)
    @sync = sync
    @tests_updated_at = SyncTests.new(Time.at(0)).call if @sync
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

      @tests_updated_at = SyncTests.new(@tests_updated_at).call if @sync

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
