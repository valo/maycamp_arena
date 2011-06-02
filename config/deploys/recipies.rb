require 'fileutils'

def read_db_config(file, env)
  YAML.load_file(file)[env]
end

def get_settings
  get(File.join(shared_path, "config/database.yml"), "tmp/database.yml")
  stage_db_settings = read_db_config("tmp/database.yml", "production")
  prod_db_settings = read_db_config("tmp/database.yml", "arena_production")
  FileUtils.rm "tmp/database.yml"
  
  [stage_db_settings, prod_db_settings]
end

def timestamp
  Time.now.utc.strftime("%Y%m%d%H%M%S")
end

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts
namespace :deploy do
  namespace :web do
    task :disable do
      run "cp #{File.join(current_path, 'public/construction.html')} #{File.join(current_path, 'public/index.html')}"
    end
    
    task :enable do
      run "rm #{File.join(current_path, 'public/index.html')}"
    end
  end
  
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do 
    pid = capture("cat #{unicorn_pid}").strip
    run "kill #{pid}" unless pid == ""
  end

  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    pid = capture("cat #{unicorn_pid}").strip
    run "kill -s QUIT #{pid}" unless pid == ""
  end

  task :reload, :roles => :app, :except => { :no_release => true } do
    pid = capture("cat #{unicorn_pid}").strip
    run "kill -s USR2" unless pid == ""
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    pid = capture("cat #{unicorn_pid}").strip
    stop unless pid == ""
    start
  end
end

namespace :sets do
  task :sync_local do
    local_backup = File.expand_path("tmp/sets")
    remote_loc = File.join(shared_path, "sets")
    FileUtils.mkdir_p local_backup
    system "rsync -azv -e ssh --delete #{user}@#{application}:#{remote_loc} #{local_backup}"
  end
end

namespace :db do
  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/sets #{release_path}/sets"
  end
  
  task :sync do
    stage_db_settings, prod_db_settings = get_settings
    run "mysqldump #{prod_db_settings["database"]} -h #{prod_db_settings["host"]} -u #{prod_db_settings["username"]} -p#{prod_db_settings["password"]} | mysql #{stage_db_settings["database"]} -u #{stage_db_settings["username"]} -p#{stage_db_settings["password"]} -h #{stage_db_settings["host"]}"
  end
  
  task :backup do
    stage_db_settings, prod_db_settings = get_settings
    puts prod_db_settings.inspect
    backup_file = "#{shared_path}/backup_#{timestamp}.bz2"
    run "mysqldump #{prod_db_settings["database"]} -h #{prod_db_settings["host"]} -u #{prod_db_settings["username"]} -p#{prod_db_settings["password"]} | bzip2 > #{backup_file}"
    get backup_file, File.join("tmp", File.basename(backup_file))
    run "rm #{backup_file}"
  end
  
  task :sync_local do
    backup
    latest_backup = Dir["tmp/backup_*.bz2"].sort.last
    local_db_settings = read_db_config("config/database.yml", "development")
    system "bzcat #{latest_backup} | mysql #{local_db_settings["database"]} -u #{local_db_settings["username"]} -p #{local_db_settings["password"]}"
  end
end

namespace :log do
  task :tail do
    run "tail -f #{File.join(shared_path, "log/production.log")}"
  end
end

after "deploy:finalize_update", "db:symlink"

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, 'vendor/bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --deployment --without test development"
  end
end
 
after 'deploy:update_code', 'bundler:bundle_new_release'