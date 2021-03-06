# -*- encoding : utf-8 -*-

# Whenever (crontab)
set :whenever_variables, -> { "stage=#{fetch(:stage)}" }
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

# Configurações do deploy padrão Capistrano:
set :application, 'homologacao.github.tcc.moodle.ufsc.br'
set :repo_url, 'https://github.com/UFSC/moodle-tcc.git'
set :git_strategy, Capistrano::SCM::Git::WithSubmodules

set :bundle_binstubs, nil # não gerar binstubs via bundler, por causa do Rails 4.x

# set :format, :pretty
set :log_level, :info
#set :log_level, :debug
# set :pty, true

# Capistrano Db Tasks:
# if you want to remove the dump file after loading
set :db_local_clean, true

# Capistrano Upload Config:
set :config_files, %w{config/database.yml config/email.yml config/errbit.yml config/newrelic.yml
                      config/tcc_config.yml config/sidekiq.yml config/secrets.yml}
set :config_example_prefix, '.example'

set :linked_files, fetch(:config_files)
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/assets public/uploads}

set :default_env, {'LANG' => 'pt_BR.UTF-8'}
set :keep_releases, 10

set :ssh_options, {
    forward_agent: true,
    port: 2200,
#    verbose: :debug
}
set :pty, true

set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}

set :rvm_map_bins, %w{gem rake rails ruby bundle sidekiq sidekiqctl}

# if you have a config/sidekiq.yml, set this.
# set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
set :sidekiq_processes,           1
set :sidekiq_options_per_process, ["-c 16"]     # threads per process
namespace :deploy do

  desc 'Configura base de dados inicial.'
  task :setup_db do
    on roles(:db) do
      strategy.deploy!
      linka_dependencias
      bundle.install
      #run "cd #{release_path} && #{rake} db:create RAILS_ENV=#{rails_env}"
      execute :cd, "#{release_path} && #{rake} db:create RAILS_ENV=#{rails_env}"
    end
  end

  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
end
