set :deploy_to, '/home/gabriel/tcc.unasus.ufsc.br'

role :web, 'tcc.unasus.ufsc.br'                          # Your HTTP server, Apache/etc
role :app, 'tcc.unasus.ufsc.br'                          # This may be the same as your `Web` server
role :db,  'tcc.unasus.ufsc.br', :primary => true        # This is where Rails migrations will run

# Verificação de dependências
shared_files = %w(database.yml moodle.yml tcc_config.yml errbit.yml email.yml new_relic.yml)
shared_files.each do |rfile|
    depend :remote, :file, File.join(deploy_to, 'shared', rfile)
end

shared_folders = %w(uploads)
shared_folders.each do |rfolder|
    depend :remote, :directory, File.join(deploy_to, 'shared', rfolder)
end

# Newrelic
require 'new_relic/recipes'
depend :remote, :file, "#{File.join(deploy_to, 'shared', 'newrelic.yml')}"

namespace :deploy do
  after 'deploy:update', 'newrelic:notice_deployment'
end
