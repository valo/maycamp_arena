class GradeRun
  def initialize(run, tests = nil, dry_run = false)
    @run = run
    @tests = tests
    @dry_run = dry_run
  end

  def call(run, dry_run = false)
    run.update_attributes(:status => Run::JUDGING) unless dry_run

    puts "Judging run with id #{run.id}"
    
    Dir.chdir(File.join(Rails.root, "sandbox")) do
      File.open("grader.log", "w") do |f|
        f.sync = true
        self.class.with_stdout_and_stderr(f, f) do
          # Compile
          if !compile(run)
            puts "Can't compile source code of run #{run.id}"
            run.update_attributes(:status => (["ce"] * tests).join(" "), :log => File.read("grader.log")) unless dry_run
            return
          end

          status = run_tests(run, tests)
          puts "final result: #{status.inspect}"
          
          run.update_attributes(:status => status, :log => File.read("grader.log")) unless dry_run
        end
      end
    end
  end

  private

    attr_reader :run, :tests, :dry_run

    def compile(run)
      if source_code_filename.blank?
        puts "Cannot determine the name of the source code of run #{run.id}"
        return
      end

      File.open(source_code_filename, "w") do |f|
        f.write(run.source_code)
      end

      if run.language == Run::LANG_C_CPP
        puts "Compiling..."
        verbose_system "g++ program.cpp -o program -O2 -static -lm -x c++"
      elsif run.language == Run::LANG_JAVA
        puts "Compiling..."
        verbose_system "javac #{"#{ run.public_class_name }.java"}"
      else
        return true
      end

      $?.exitstatus != 0
    end

    def run_tests(run, tests)
      # for each test, run the program
      run.problem.input_files[0...tests].zip(run.problem.output_files).map { |input_file, answer_file|
        verbose_system "docker -i -t -v `pwd`/sandbox:/sandbox -v #{input_file}:/sandbox/input -m #{run.problem.memory_limit} -d valo/maycamp_arena_grader #{executable} < input"
        container_id = `docker ps -l --no-trunc | tail -n 1 | cut -d " " -f 1`

        exit_status = wait_while_finish(run.timeout, container_id)
        
        case exit_status
          when 9
            "tl"
          when 127
            "ml"
          when 0
            check_output(run, answer_file, input_file)
          else
            "re"
        end
      }.join(" ")
    end

    def check_output(run, answer_file, input_file)
      if checker = run.problem.checker
        verbose_system "#{checker} #{input_file} #{answer_file} output"
      else
        checker = File.join(Rails.root, "ext/diff.rb")
        verbose_system "#{checker} #{run.problem.diff_parameters} #{answer_file} output"
      end
      
      if $?.exitstatus != 0
        "wa"
      else
        "ok"
      end
    end

    def source_code_filename
      case(run.language)
      when Run::LANG_JAVA
        "#{ run.public_class_name }#{Run::EXTENSIONS[run.language]}"
      else
        "program#{Run::EXTENSIONS[run.language]}"
      end
    end

    def executable
      case(run.language)
      when Run::LANG_JAVA
        "java #{ run.public_class_name }.java"
      when Run::LANG_C_CPP
        "./program"
      when Run::LANG_PYTHON2
        "python program#{Run::EXTENSIONS[run.language]}"
      end
    end

    def verbose_system(cmd)
      puts cmd
      system cmd
      puts "status: #{$?.exitstatus}"
    end

    def self.with_stdout_and_stderr(new_stdout, new_stderr, &block)
      old_stdout, old_stderr = $stdout.dup, $stderr.dup
      STDOUT.reopen(new_stdout)
      STDERR.reopen(new_stderr)
      
      yield
    ensure
      STDOUT.reopen(old_stdout)
      STDERR.reopen(old_stderr)
    end

    def tests
      @tests ||= run.problem.number_of_tests
    end

    def wait_while_finish(timeput, container_id)
      while (`docker inspect -f {{.State.Running}})` == "true") do
        sleep(1)

        if 
      end
    end
end
