# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'log-guard'
# set :repo_url, 'git@example.com:me/my_repo.git'
set :repo_url, 'git@github.com:databox/databox-log-guard.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/otobrglez/apps/log-guard'


# Default value for :scm is :git
# set :scm, :git
# set :repository, "."
# set :scm, :none
set :deploy_via, :copy

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/config.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp', 'vendor/bundle')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "Start the Unicorn process when it isn't already running."
  task :start do
    on roles(:all) do
      within "#{fetch(:deploy_to)}/current/" do
        execute :bundle, :exec, :unicorn, "-D", "--env", fetch(:rails_env, "production"), "-p", "8080", "-c", "./config/unicorn.rb"
      end
    end
  end

  desc 'Reload Unicorn without killing master process'
  task :reload do
    on roles(:all) do
      if test("[ -f #{fetch(:deploy_to)}/current/tmp/unicorn.pid ]")
        execute :kill, '-s USR2', capture(:cat, "#{fetch(:deploy_to)}/current/tmp/unicorn.pid")
      else
        error 'Unicorn process not running'
      end
    end
  end
end
