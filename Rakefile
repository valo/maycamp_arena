# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

Rake.application.options.trace = true

task :create_db do
  cmd_string = %[mysqladmin create spoj0_test -u build]
  system cmd_string
  system "mkdir sets"
end

namespace :test do
  task :grader do
    Dir.chdir File.join(RAILS_ROOT, "test/grader") do
      system "./test_runner.pl"
    end
  end
end
 
def runcoderun?
  ENV["RUN_CODE_RUN"]
end
 
if runcoderun?
  task :default => [:create_db, :cucumber]
else
  task :default => :cucumber
end
