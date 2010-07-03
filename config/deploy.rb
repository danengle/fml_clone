set :application, "fml_clone"
set :repository,  "git@github.com:danengle/fml_clone.git"
set :deploy_to, "/home/dan/apps/fml.danengle.me"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "danengle.me"                          # Your HTTP server, Apache/etc
role :app, "danengle.me"                          # This may be the same as your `Web` server
role :db,  "danengle.me", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :user, "dan"
set :scm_username, "danengle"
set :use_sudo, false

#set :default_environment, { 
#  'PATH' => "/home/danengle/.rvm/rubies/ruby-1.9.2-preview3/bin:/home/danengle/.rvm/gems/ruby-1.9.2-preview3/bin:/home/danengle/.rvm/bin:$PATH",
#  'RUBY_VERSION' => 'ruby 1.9.2',
#  'GEM_HOME' => '/home/danengle/.rvm/gems/ruby-1.9.2-preview3/gems',
#  'GEM_PATH' => '/home/danengle/.rvm/gems/ruby-1.9.2-preview3/gems' 
#}

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end