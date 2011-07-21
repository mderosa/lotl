set :application, "lotl"

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                               # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ruby-1.9.2-p290@rails3'         # Or whatever env you want it to run in.
set :rvm_type, :user 


set :repository,  "git@github.com:mderosa/lotl.git"
set :scm, :git
set :scm_username, "git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, "parsival"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false

ssh_options[:forward_agent] = true

role :web, "192.168.2.9"                          # Your HTTP server, Apache/etc
role :app, "192.168.2.9"                          # This may be the same as your `Web` server
role :db,  "192.168.2.9", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do

  desc "cause Passenger to initiate a restart"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:update_code", :bundle_install
desc "install the necessary prerequisites"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end
