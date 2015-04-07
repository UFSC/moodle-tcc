set :stage, :vmlocal

set :application, 'tcc.vmlocal'
set :deploy_to, '/home/deploy/tcc'
set :branch, 'master'
set :rails_env, 'production'

set :ssh_options, {
                    forward_agent: true,
                    port: 22,
                    #    verbose: :debug
                }

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'tcc.vmlocal', user: 'deploy', roles: %w{web app db}

# fetch(:default_env).merge!(rails_env: :production)

# namespace :deploy do
#   before :finished, 'newrelic:notice_deployment'
# end

set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
