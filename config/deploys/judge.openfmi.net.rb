set :application, "maycamp"
set :branch, "master"
set :port, 9222

set :user, "contest"
set :home_path, "/home/#{user}"

roles.clear
role :web, "judge.openfmi.net"                          # Your HTTP server, Apache/etc
role :app, "judge.openfmi.net"                          # This may be the same as your `Web` server
role :db,  "judge.openfmi.net", :primary => true # This is where Rails migrations will run
