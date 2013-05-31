#require "rvm/capistrano"
ssh_options[:forward_agent] = true
ssh_options[:username] = 'irfan'
default_run_options[:pty] = true

set :bundle_cmd, "/usr/local/bin/bundle"



set :scm_verbose, true
set :runner, "irfan"
set :user, 'irfan'

set :application, "GigPointForMusician"
set :repository,  "https://irfann@bitbucket.org/rslingo/gigpoint-for-musicians.git"
set :branch, 'master'
set :use_sudo, true
set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "build.gig-point.com"                          # Your HTTP server, Apache/etc
role :app, "build.gig-point.com"                          # This may be the same as your `Web` server
role :db,  "build.gig-point.com", :primary => true # This is where Rails migrations will run
role :db,  "build.gig-point.com"

set :deploy_to, "/home/irfan/public_html/#{application}"
set :deploy_env, 'production'

set :whenever_command, "bundle exec whenever"
require 'whenever/capistrano'

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :start do
  end

  task :stop do
  end

  desc "run database migration"
  task :bundle do
    run "cd #{latest_release} &&  bundle install"
  end

  desc "precompile assets"
  task :precompile do
    run "cd #{latest_release} &&  bundle exec rake assets:precompile"
  end

  desc "bundle install"
  task :bundle_install do
    run "cd #{latest_release} && sudo  bundle install  --path #{shared_path}/bundle"
  end

  task :db_migrate do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate "
  end

  desc "restart passenger"
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#sudo touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "#{try_sudo} rm #{latest_release}/config/database.yml"
    run "#{try_sudo} ln -s #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end

  desc "Symlinks the database.yml"
  task :remove_old_symlink_db, :roles => :app do
    run "rm #{latest_release}/config/database.yml"
    run "rm #{latest_release}/config/mongoid.yml"
  end




  desc "Restarting delayed job"
  task :restart_delayed_job, :roles => :app do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec script/delayed_job stop"
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec script/delayed_job start"
  end


  desc "Set permission for temp file"
  task :set_permission do
    run " sudo chmod -R 777 #{latest_release}"
    run " sudo chmod -R 777 #{shared_path}"
  end

  desc "Set permission for vendor/bundle"
  task :set_permission_for_vendor do
    run "cd #{latest_release}/vendor && sudo chmod -R 777 bundle/"
  end
  desc "Set permission for .bundle/"
  task :set_permission_for_bundle do
    run "cd #{latest_release} && sudo chmod -R 777 .bundle/"
  end
  desc "Set ownership for releases"
  task :set_ownership_for_releases do
    run "#{sudo} chown -R #{runner} #{latest_release}"
  end

  desc "assets precompile"
  task :precompile_asset do
    run "cd #{latest_release} && sudo bundle exec rake assets:clean "
    run "cd #{latest_release} && sudo bundle exec rake assets:precompile "
  end

  desc "change branch"
  task :change_branch do
    run "cd #{latest_release} && git branch checkout master"
  end



end



before "whenever:update_crontab", "deploy:change_branch", "deploy:bundle_install" , "deploy:set_permission", "deploy:symlink_db", "deploy:db_migrate","deploy:set_permission" ,"deploy:set_ownership_for_releases" ,"deploy:precompile_asset","deploy:set_permission" ,"deploy:set_ownership_for_releases" ,"deploy:restart", "deploy:set_permission" ,"deploy:set_ownership_for_releases"
#after "deploy:copy_bundler", "deploy:bundle_install"
#before "deploy:db_migrate", "deploy:symlink_db"
