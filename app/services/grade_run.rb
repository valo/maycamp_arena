class GradeRun
  def initialize(run, tests = nil, dry_run = false)
    @run = run
    @tests = tests
    @dry_run = dry_run
  end

  def call
    run.update_attributes(:status => Run::JUDGING) unless dry_run

    puts "Judging run with id #{run.id} with #{tests} tests"

    Dir.chdir(File.join(Rails.root, "sandbox")) do
      File.open("grader.log", "w") do |f|
        f.sync = true
        self.class.with_stdout_and_stderr(f, f) do
          FileUtils.rm_rf("*")

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

        docker_cleanup
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

      $?.exitstatus == 0
    end

    def run_tests(run, tests)
      # for each test, run the program
      run.problem.input_files[0...tests].zip(run.problem.output_files).map { |input_file, answer_file|
        command = %Q{docker run #{ mappings(input_file) }\
          -m #{docker_memory_limit}\
          --cpuset=0\
          -u grader -d --net=none grader\
           /sandbox/runner_fork.rb -i /sandbox/input -o /sandbox/output -p 50 -m #{memory_limit} -t #{ timeout } -- #{ executable }}
        puts command
        container_id = %x{#{ command }}
        puts "Running #{ executable } in container #{ container_id }"

        exit_status = wait_while_finish(container_id)

        puts docker_logs(container_id)
        puts "Container exit status: #{ exit_status }"

        exit_status = 127 if docker_oomkilled(container_id)

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

    def mappings(input_file)
      {
        "#{Rails.root}/sandbox" => "/sandbox",
        "#{Rails.root}/ext/runner_args.rb" => "/sandbox/runner_args.rb",
        "#{Rails.root}/ext/runner_fork.rb" => "/sandbox/runner_fork.rb",
        "#{input_file}" => "/sandbox/input"
      }.map do |from, to|
        "-v #{from}:#{to}"
      end.join(" ")
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
        "/usr/bin/java -Xmx512m #{ run.public_class_name }"
      when Run::LANG_C_CPP
        "/sandbox/program"
      when Run::LANG_PYTHON2
        "/usr/bin/python2.7 program#{ Run::EXTENSIONS[run.language] }"
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

    def timeout
      run.problem.time_limit
    end

    def memory_limit
      run.problem.memory_limit
    end

    def docker_memory_limit
      [memory_limit, 4 * 1024 * 1024].max
    end

    def wait_while_finish(container_id)
      while docker_finished_at(container_id).blank? do
        sleep(1)
      end

      docker_exitcode(container_id)
    end

    def docker_running_state(container_id)
      `docker inspect -f '{{.State.Running}}' #{container_id}`.strip
    end

    def docker_finished_at(container_id)
      `docker inspect -f '{{.State.FinishedAt}}' #{container_id}`.strip
    end

    def docker_exitcode(container_id)
      `docker inspect -f '{{.State.ExitCode}}' #{container_id}`.to_i
    end

    def docker_oomkilled(container_id)
      `docker inspect -f '{{.State.OOMKilled}}' #{container_id}`.strip == "true"
    end

    def docker_logs(container_id)
      `docker logs #{container_id}`.strip
    end

    def docker_cleanup
      `docker rm $(docker ps -aq)`
    end
end
