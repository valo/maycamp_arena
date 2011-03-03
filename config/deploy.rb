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

role :web, "89.252.247.77"                          # Your HTTP server, Apache/etc
role :app, "89.252.247.77"                          # This may be the same as your `Web` server
role :db,  "89.252.247.77", :primary => true # This is where Rails migrations will run
