class Grader
  attr_reader :root, :user, :runner

  class << self
    def with_stdout_and_stderr(new_stdout, new_stderr, &block)
      old_stdout, old_stderr = $stdout.dup, $stderr.dup
      STDOUT.reopen(new_stdout)
      STDERR.reopen(new_stderr)
      
      yield
    ensure
      STDOUT.reopen(old_stdout)
      STDERR.reopen(old_stderr)
    end
  end

  def initialize(root, user, grader_app = nil)
    @root = root
    @user = user
    
    if grader_app
      SetsSync.sync_sets(grader_app)
    end
  end
  
  def run
    running = true
    puts "Ready to grade"
    
    while running do
      Signal.trap("TERM") do
        puts "Stopping..."
        running = false
      end
      
      Signal.trap("INT") do
        puts "Stopping..."
        running = false
      end
      
      sleep 1
      run = Run.find_by_status(Run::WAITING)
      next unless run
      
      run.update_attributes(:status => Run::JUDGING)
      puts "Judging run with id #{run.id}"
      @runner = Pathname.new("../runner.pl").realpath.to_s
      
      Dir.chdir @root do
        old_stdout, old_stderr = $stdout, $stderr
        
        File.open("grader.log", "w") do |f|
          f.sync = true
          self.class.with_stdout_and_stderr(f, f) do
            # Compile
            compile(run)

            if $? != 0
              run.update_attributes(:status => "ce", :log => File.read("grader.log"))
              next
            end

            status = run_tests(run)
            puts "final result: #{status.inspect}"
            run.update_attributes(:status => status, :log => File.read("grader.log"))
          end
        end
      end
    end
  end
  
  private
    def compile(run)
      File.open("program.cpp", "w") do |f|
        f.write(run.source_code)
      end
      
      puts "Compiling..."
      puts cmd = "#{@runner} --user #{@user} -- g++ program.cpp -o program"
      system cmd
      puts "status: #{$?.inspect}"
    end
    
    def run_tests(run)
      # for each test, run the program
      run.problem.input_files.zip(run.problem.output_files).map { |input_file, output_file|
        puts cmd = "#{@runner} --user #{@user} --time #{run.problem.time_limit} -- ./program < #{input_file} > output"
        system cmd
        puts "status: #{$?.exitstatus}"
        
        case $?.exitstatus
          when 9
            "tl"
          when 127
            "ml"
          when 0
            puts cmd = "diff #{output_file} output"
            system cmd
            puts "status: #{$?.exitstatus}"
          
            if $? != 0
              "wa"
            else
              "ok"
            end
          else
            "re"
        end
      }.join(" ")
    end
end
