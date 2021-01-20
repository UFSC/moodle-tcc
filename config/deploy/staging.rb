# Figure out the name of the current local branch
def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  puts "* Using branch: #{branch}"
  branch
end

set :stage, :staging

set :deploy_to, '/home/deploy/homologacao-github-tcc.moodle.ufsc.br'
set :branch, current_git_branch
set :rails_env, 'production'

# RVM
set :rvm_type, :deploy                     # Defaults to: :auto
set :rvm_ruby_version, 'ruby-2.4.9@sistema-tcc'      # Defaults to: 'default'
set :rvm_custom_path, '/usr/local/rvm'  # only needed if not detected

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'homologacao-github-tcc.moodle.ufsc.br', user: 'deploy', roles: %w{web app db} #, port: 2200

# fetch(:default_env).merge!(rails_env: :staging)

# Sidekiq
# =======
set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

# namespace :deploy do
#   before :finished, 'newrelic:notice_deployment'
# end