set :application, "twitpuzzle"             # APPL-NAME  をアプリのプロジェクト名に設定
set :repository,  ""    # GIT-REPOSITORY-URLに Gitサーバー上のリポジトリのURLを設定
set :server_ip, ""                  # SERVER-IPにサーバーのIP アドレスを設定

set :scm, :git
set :scm_command, :git
set :use_sudo, false

set :ssh_options, { :forward_agent => true, :port => 10022 }

set :deploy_to, "/var/www/app/#{application}" 
set :branch, :master

set :default_environment, {
    'PATH' => "/opt/ruby-2.0.0-p0/bin/:$PATH" 
}
load 'deploy/assets'
require "bundler/capistrano" 

set :rails_env, :production
set :rake, "bundle exec rake" 

role :web, server_ip
role :app, server_ip
role :db,   server_ip, :primary => true

set :unicorn_binary, "unicorn_rails" 
set :unicorn_config, "#{current_path}/config/unicorn.rb" 
set :unicorn_pid,    "#{current_path}/tmp/pids/unicorn.pid" 

namespace :deploy do
  desc "Start Application" 
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{try_sudo} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D" 
  end
  desc "Stop Application" 
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "test -f #{unicorn_pid} && #{try_sudo} kill `cat #{unicorn_pid}` || echo 'skip'" 
  end
  desc "Stop Application gracefully" 
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "test -f #{unicorn_pid} && #{try_sudo} kill -s QUIT `cat #{unicorn_pid}` || echo 'skip'" 
  end
  desc "Reload Application" 
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "test -f #{unicorn_pid} && #{try_sudo} kill -s USR2 `cat #{unicorn_pid}` || echo 'skip'" 
  end
  desc "Restart Application" 
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
  desc "Load fixtures" 
  task :fixtures_load, :roles => :app do
    run "cd #{current_release} && RAILS_ENV=production FIXTURES_PATH=spec/fixtures bundle exec rake db:fixtures:load" 
  end
end