#require "rvm/capistrano"
ssh_options[:forward_agent] = true
ssh_options[:username] = 'irfan'
default_run_options[:pty] = true



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
    run "cd #{latest_release} && sudo  bundle install --no-deployment"
    run "cd #{latest_release} && sudo  bundle install --deployment"
  end

  task :db_migrate do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate "
  end

  desc "restart passenger"
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
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

  desc "Symlinks the database.yml"
  task :set_qa_environment, :roles => :app do
    run "#{try_sudo} rm  #{latest_release}/config.ru"
    run "#{try_sudo} ln -s #{shared_path}/config/config.ru #{latest_release}/config.ru"
  end

  desc "Symlinks shared folder to upload files"
  task :symlink_folder_to_upload, :roles => :app do
    run "#{try_sudo} rm -rf #{latest_release}/public/system"
    run "#{try_sudo} ln -s #{shared_path}/system/ #{latest_release}/public/system"
  end

  desc "Restarting delayed job"
  task :restart_delayed_job, :roles => :app do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec script/delayed_job stop"
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec script/delayed_job start"
  end

  desc "copy_rvmrc"
  task :trust_rvmrc, :roles => :app do
    #run "cp #{shared_path}/config/rvmrc #{latest_release}/.rvmrc"
    run "rvm rvmrc trust #{latest_release}"
  end

  desc "Set permission for temp file"
  task :set_permission do
    run "cd #{latest_release} && #{try_sudo} chmod -R 777 tmp/"
  end

  desc "Set permission for vendor/bundle"
  task :set_permission_for_vendor do
    run "cd #{latest_release}/vendor && #{try_sudo} chmod -R 777 bundle/"
  end
  desc "Set permission for .bundle/"
  task :set_permission_for_bundle do
    run "cd #{latest_release} && #{try_sudo} chmod -R 777 .bundle/"
  end
  desc "Set ownership for releases"
  task :set_ownership_for_releases do
    run "#{try_sudo} chown -R #{runner} #{latest_release}"
  end

  desc "copy vendor/bundle to current directory"
  task :copy_bundler do
    run "#{try_sudo} rm -rf  #{latest_release}/vendor/bundle"
    run "#{try_sudo} ln -s #{shared_path}/bundle #{latest_release}/vendor/bundle"
  end

  desc "remove vendor/bundle to current directory"
  task :remove_vendor do
    run "#{try_sudo} rm -rf  #{latest_release}/vendor/bundle"
  end

  desc "repair checkins and allocated"
  task :repair_check_ins do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake repair_resource:checkin "
  end

  desc "clear basic data"
  task :clear_data do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake clear_data:all "
  end

end

namespace :bundle do
  desc "Install Bundler"
  task :install do
    run  "cd #{latest_release} && bundle install --path vendor/bundle --deployment --quiet --without development test"
  end
  desc "Install Bundler"
  task :install_without_sudo do
    run  "cd #{latest_release} && bundle install --path vendor/bundle --deployment --quiet --without development test"
  end
end


#before  "deploy:bundle_install", "deploy:trust_rvmrc"
before  "deploy:bundle_install", "deploy:copy_bundler"
after "deploy", "deploy:bundle_install"
before "deploy:db_migrate", "deploy:symlink_db"
after "deploy:bundle_install", "deploy:db_migrate"
after "deploy", "deploy:restart"
#after "deploy:copy_bundler", "deploy:bundle_install"
#before "deploy:db_migrate", "deploy:symlink_db"