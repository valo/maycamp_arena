set :application, "maycamp"
set :branch, "master"
set :port, 22

set :user, "grader"
set :home_path, "/home/#{user}"

roles.clear
role :web, "grader.valentinmihov.com"                          # Your HTTP server, Apache/etc
role :app, "grader.valentinmihov.com"                          # This may be the same as your `Web` server
role :db,  "grader.valentinmihov.com", :primary => true # This is where Rails migrations will run
