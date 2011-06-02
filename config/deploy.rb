
DEPLOY_STAGE = ENV['STAGE'] || "staging"

load File.join(File.dirname(__FILE__), "deploys", DEPLOY_STAGE)
load File.join(File.dirname(__FILE__), "deploys/recipies")

set :repository, "git://github.com/valo/maycamp_arena.git"
set :user, "maycamp"
set :home_path, "/home/maycamp"
set :deploy_to, File.join(home_path, application)
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, :git
set :git_enable_submodules, 1

role :web, "maycamp.com"                          # Your HTTP server, Apache/etc
role :app, "maycamp.com"                          # This may be the same as your `Web` server
role :db,  "maycamp.com", :primary => true # This is where Rails migrations will run

set :rails_env, :production
set :unicorn_binary, "bundle exec unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.conf.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end