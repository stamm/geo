set :application, 'geo'
set :repo_url, 'git@github.com:stamm/geo.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/rails/geo'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml config/unicorn.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, { path: "/usr/local/rbenv/shims/:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'deploy:unicorn:restart'
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

  namespace :unicorn do
    pid_path = "#{release_path}/tmp/pids"
    unicorn_pid = "#{pid_path}/unicorn.pid"

    def run_unicorn
      execute "#{fetch(:bundle_binstubs)}/unicorn", "-c #{release_path}/config/unicorn.rb -D -E #{fetch(:stage)}"
    end

    desc 'Start unicorn'
    task :start do
      on roles(:app) do
        run_unicorn
      end
    end

    desc 'Stop unicorn'
    task :stop do
      on roles(:app) do
        if test "[ -f #{unicorn_pid} ]"
          execute :kill, "-QUIT `cat #{unicorn_pid}`"
        end
      end
    end

    desc 'Force stop unicorn (kill -9)'
    task :force_stop do
      on roles(:app) do
        if test "[ -f #{unicorn_pid} ]"
          execute :kill, "-9 `cat #{unicorn_pid}`"
          execute :rm, unicorn_pid
        end
      end
    end

    desc 'Restart unicorn'
    task :restart do
      on roles(:app) do
        if test "[ -f #{unicorn_pid} ]"
          execute :kill, "-USR2 `cat #{unicorn_pid}`"
        else
          run_unicorn
        end
      end
    end
  end
end

