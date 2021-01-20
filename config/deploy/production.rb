set :stage, :production

set :deploy_to, '/home/deploy/homologacao-github-tcc.moodle.ufsc.br'
set :branch, 'master'
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
server 'homologacao-github-tcc.moodle.ufsc.br', user: 'deploy', roles: %w{web app db}, port: 2200

# fetch(:default_env).merge!(rails_env: :production)

set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

# namespace :deploy do
#   before :finished, 'newrelic:notice_deployment'
# end