set :application, "sarena.maycamp.com"
set :repository,  "git://github.com/valo/spoj0.git"

set :scm, :git
set :branch, "v0.2RC"
set :user, "maycamp"
set :deploy_to, "/home/maycamp/#{application}"
set :use_sudo, false
set :database_name, "sarena"

role :web, application                          # Your HTTP server, Apache/etc
role :app, application                          # This may be the same as your `Web` server
role :db,  application, :primary => true # This is where Rails migrations will run

namespace :db do
  task :backup, :roles => :db do
    
  end
end

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :db do
  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  
  task :sync do
    run "mysqldump spoj0_prod -h mysql.maycamp.com -u admin_spoj0 -pparola | mysql sarena -u admin_staging -pparola -h mysql.maycamp.com"
  end
  
  task :backup do
    backup_file = "#{shared_path}/backup_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    run "mysqldump spoj0_prod -h mysql.maycamp.com -u admin_spoj0 -pparola > #{backup_file}"
    get backup_file, "backup"
  end
end

after "deploy:finalize_update", "db:symlink"