set :application, "sarena.maycamp.com"
set :repository,  "git://github.com/valo/spoj0.git"

set :scm, :git
set :branch, "v0.2RC"
set :user, "maycamp"
set :home_path, "/home/maycamp"
set :deploy_to, File.join(home_path, application)
set :use_sudo, false
set :database_name, "sarena"

role :web, application                          # Your HTTP server, Apache/etc
role :app, application                          # This may be the same as your `Web` server
role :db,  application, :primary => true # This is where Rails migrations will run

def get_settings
  get(File.join(shared_path, "config/database.yml"), "tmp/database.yml")
  stage_db_settings = YAML.load_file("tmp/database.yml")["production"]
  prod_db_settings = YAML.load_file("tmp/database.yml")["arena_production"]
  FileUtils.rm "tmp/database.yml"
  
  [stage_db_settings, prod_db_settings]
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
    stage_db_settings, prod_db_settings = get_settings
    run "mysqldump #{prod_db_settings["database"]} -h #{prod_db_settings["host"]} -u #{prod_db_settings["username"]} -p#{prod_db_settings["password"]} | mysql #{stage_db_settings["database"]} -u #{stage_db_settings["username"]} -p#{stage_db_settings["password"]} -h #{stage_db_settings["host"]}"
  end
  
  task :backup do
    stage_db_settings, prod_db_settings = get_settings
    backup_file = "#{shared_path}/backup_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}.bz2"
    run "mysqldump #{prod_db_settings["database"]} -h #{prod_db_settings["host"]} -u #{prod_db_settings["username"]} -p#{prod_db_settings["password"]} | bzip2 > #{backup_file}"
    get backup_file, File.join("tmp", File.basename(backup_file))
  end
end

after "deploy:finalize_update", "db:symlink"
