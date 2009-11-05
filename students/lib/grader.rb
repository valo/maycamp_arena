require File.join(File.dirname(__FILE__), "shell_utils")

class Grader
  include ShellUtils
  attr_reader :root, :user, :runner, :tests_updated_at, :grader_app
  
  LANG_TO_COMPILER = {}

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

  def initialize(root, user)
    @root = root
    @user = user
    
    sync_tests
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
      
      sleep 1
      check_durty_tests
      run = Run.find_by_status(Run::WAITING)
      
      if run
        grade(run)
      else
        run = Run.find_by_status(Run::CHECKING)
        grade(run, 1) if run
      end
    end
  end
  
  private
    def grade(run, tests = nil)
      tests ||= run.problem.number_of_tests
      run.update_attributes(:status => Run::JUDGING)
      puts "Judging run with id #{run.id}"
      @runner = Pathname.new("../runner.rb").realpath.to_s
      
      Dir.chdir @root do
        File.open("grader.log", "w") do |f|
          f.sync = true
          self.class.with_stdout_and_stderr(f, f) do
            # Compile
            compile(run)

            if $?.exitstatus != 0
              run.update_attributes(:status => (["ce"] * tests).join(" "), :log => File.read("grader.log"))
              next
            end

            status = run_tests(run, tests)
            puts "final result: #{status.inspect}"
            run.update_attributes(:status => status, :log => File.read("grader.log"))
          end
        end
      end
    end
    
    def compile(run)
      File.open("program.cpp", "w") do |f|
        f.write(run.source_code)
      end
      
      puts "Compiling..."
      verbose_system "g++ program.cpp -o program -O2 -s -static -lm -x c++"
    end
    
    def run_tests(run, tests)
      # for each test, run the program
      count = 0;
      run.problem.input_files.zip(run.problem.output_files).map { |input_file, output_file|
        return if count > tests
        count += 1
        
        verbose_system "#{@runner} --user #{@user} --time #{run.problem.time_limit} --mem #{run.problem.memory_limit} --procs 1 -- ./program < #{input_file} > output"
        
        case $?.exitstatus
          when 9
            "tl"
          when 127
            "ml"
          when 0
            verbose_system "diff #{output_file} output --strip-trailing-cr"
          
            if $?.exitstatus != 0
              "wa"
            else
              "ok"
            end
          else
            "re"
        end
      }.join(" ")
    end

    def sync_tests
      SetsSync.sync_sets(get_config)
      @tests_updated_at = Time.now
    end

    def check_durty_tests
      if (last_update = Configuration.get(Configuration::TESTS_UPDATED_AT)) and last_update > @tests_updated_at
        # Download the tests again
        sync_tests
      end
    end
end
