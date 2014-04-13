# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'arena.maycamp.com'
set :repo_url, 'git://github.com/valo/maycamp_arena.git'

set :rvm_type, :user
set :rvm_ruby_version, '2.1.1'

set :puma_config_file, "config/puma.rb"
set :puma_conf, "#{shared_path}/config/puma.rb"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/grader.yml config/secret.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log sets tmp/pids tmp/sockets}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  after :updated, "assets:precompile"

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

namespace :assets do
  desc "Precompile assets locally and then rsync to web servers"
  task :precompile do
    on roles(:web) do
      rsync_host = host.to_s # this needs to be done outside run_locally in order for host to exist
      run_locally do
        with rails_env: fetch(:stage) do
          execute :bundle, "exec rake assets:precompile"
        end
        execute "rsync -av --delete ./public/assets/ #{fetch(:user)}@#{rsync_host}:#{shared_path}/public/assets/"
        execute "rm -rf public/assets"
        # execute "rm -rf tmp/cache/assets" # in case you are not seeing changes
      end
    end
  end
end