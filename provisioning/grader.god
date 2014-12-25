God.watch do |w|
  w.name = "grader"
  w.interval = 30.seconds # default
  w.start = "cd {{ workdir }} && /home/grader/.rvm/bin/rvm 2.1 do bundle exec rake RAILS_ENV=production grader:start"
  w.start_grace = 10.seconds
  w.log = "{{ workdir }}/grader.log"

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end
end
