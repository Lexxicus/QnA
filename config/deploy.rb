# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "qna"
set :repo_url, "git@github.com:Lexxicus/QnA.git"
set :branch, ENV['BRANCH'] if ENV['BRANCH']
set :rvm_type, :user
set :rvm_ruby_version, '2.7.2'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/lexx/qna"
set :deploy_user, 'lexx'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'storage'
