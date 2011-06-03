DEPLOY_STAGE = ENV['STAGE'] || "default"

# This must be configured for each system maycamp is installed to
set :user, "maycamp"
set :home_path, "/home/maycamp"
set :port, 22

load File.join(File.dirname(__FILE__), "deploys", DEPLOY_STAGE)
load File.join(File.dirname(__FILE__), "deploys/recipies")

role :web, "maycamp.com"                          # Your HTTP server, Apache/etc
role :app, "maycamp.com"                          # This may be the same as your `Web` server
role :db,  "maycamp.com", :primary => true # This is where Rails migrations will run
