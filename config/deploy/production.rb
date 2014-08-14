set :stage, :production

set :deploy_to, '/home/deploy/tcc.unasus.ufsc.br'
set :branch, 'master'

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'tcc.unasus.ufsc.br', user: 'deploy', roles: %w{web app db}

# fetch(:default_env).merge!(rails_env: :production)

namespace :deploy do
  before :finished, 'newrelic:notice_deployment'
end