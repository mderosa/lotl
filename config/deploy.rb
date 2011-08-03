# deployment script for lotl
# For production run 'cap env:pro_env deploy:migrations'
# For test run 'cap env:test_env deploy:migrations

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

set :deploy_to,  do
  "/home/#{user}/apps/#{application}"
end
set :use_sudo, false

ssh_options[:forward_agent] = true

role :web, do ltl_web_server end                          # Your HTTP server, Apache/etc
role :app, do ltl_web_server end                          # This may be the same as your `Web` server
role :db, :primary => true, do ltl_web_server end         # This is where Rails migrations will run
#role :db,  "your slave db-server here"

namespace :env do
  task :test_env do
    set :user, "parsival"
    set :ltl_web_server, "192.168.2.4"
  end

  task :pro_env do
    set :user, "ubuntu"
    set :ltl_web_server, "122.248.220.253"
  end
end

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


# error: several times i forgot the comma in set :something 'xxx'
