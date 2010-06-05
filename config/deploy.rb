DEPLOY_STAGE = ENV['STAGE'] || "staging"

load File.join(File.dirname(__FILE__), "deploys", DEPLOY_STAGE)
load File.join(File.dirname(__FILE__), "deploys/recipies")

set :repository, "git://github.com/valo/spoj0.git"
set :user, "maycamp"
set :home_path, "/home/maycamp"
set :deploy_to, File.join(home_path, application)
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, :git
set :git_enable_submodules, 1

role :web, application                          # Your HTTP server, Apache/etc
role :app, application                          # This may be the same as your `Web` server
role :db,  application, :primary => true # This is where Rails migrations will run
