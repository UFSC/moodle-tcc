set :deploy_to, '/home/gabriel/tcc.unasus.ufsc.br'

# Newrelic
require 'new_relic/recipes'
depend :remote, :file, "#{File.join(deploy_to, 'shared', 'newrelic.yml')}"

namespace :deploy do
  after 'deploy:update', 'newrelic:notice_deployment'
end