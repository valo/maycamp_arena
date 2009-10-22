Rake.application.options.trace = true

task :cucumber do
  exec "cd students; rake db:migrate cucumber RAILS_ENV=cucumber"
end

task :create_db do
  cmd_string = %[mysqladmin create spoj0_test -u build]
  system cmd_string
  system "mkdir sets"
end
 
def runcoderun?
  ENV["RUN_CODE_RUN"]
end
 
if runcoderun?
  task :default => [:create_db, :cucumber]
else
  task :default => :cucumber
end
