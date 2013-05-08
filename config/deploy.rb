# -*- encoding : utf-8 -*-
require 'bundler/capistrano'
require 'new_relic/recipes'

set :application, 'tcc.unasus.ufsc.br'
set :repository,  'git@gitlab.setic.ufsc.br:tcc-unasus/sistema-tcc.git'
set :scm, :git

set :default_environment, {'LANG' => 'pt_BR.UTF-8'}
set :deploy_to, '/home/gabriel/tcc.unasus.ufsc.br'

set :ssh_options, { :forward_agent => true, :port => '2200' }

set :user, 'gabriel'
set :use_sudo, false
set :deploy_via, :remote_cache

role :web, 'tcc.unasus.ufsc.br'                          # Your HTTP server, Apache/etc
role :app, 'tcc.unasus.ufsc.br'                          # This may be the same as your `Web` server
role :db,  'tcc.unasus.ufsc.br', :primary => true        # This is where Rails migrations will run

depend :remote, :file, "#{File.join(deploy_to, 'shared', 'database.yml')}"
depend :remote, :file, "#{File.join(deploy_to, 'shared', 'newrelic.yml')}"

namespace :deploy do
  task :setup_db, :roles => :db, :desc => 'Configura base de dados inicial.' do
    strategy.deploy!
    linka_dependencias
    bundle.install
    run "cd #{release_path} && #{rake} db:create RAILS_ENV=#{rails_env}"
  end

  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  after 'deploy:update', 'newrelic:notice_deployment'

  after 'deploy:finalize_update', 'deploy:linka_dependencias'
  task :linka_dependencias, :roles => :app, :desc => 'Faz os links simbólicos com arquivos de configuração' do
    run "ln -s #{File.join(deploy_to, 'shared', 'database.yml')} #{File.join(current_release, 'config', 'database.yml')}"
    run "ln -s #{File.join(deploy_to, 'shared', 'newrelic.yml')} #{File.join(current_release, 'config', 'newrelic.yml')}"
  end
end