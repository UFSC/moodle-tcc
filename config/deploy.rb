# -*- encoding : utf-8 -*-

# Whenever (crontab)
set :whenever_variables, -> { "stage=#{fetch(:stage)}" }
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

set :application, 'tcc.unasus.ufsc.br'
set :repo_url, 'git@gitlab.setic.ufsc.br:tcc-unasus/sistema-tcc.git'
set :scm, :git

# set :format, :pretty
set :log_level, :info
# set :pty, true

# Capistrano Db Tasks:
# if you want to remove the dump file after loading
set :db_local_clean, true

# Capistrano Upload Config:
set :config_files, %w{config/database.yml config/email.yml config/errbit.yml config/moodle.yml config/newrelic.yml
                      config/tcc_config.yml}
set :config_example_prefix, '.example'

set :linked_files, fetch(:config_files)
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :default_env, {'LANG' => 'pt_BR.UTF-8'}
set :keep_releases, 10

set :ssh_options, {
    forward_agent: true,
    port: 2200
}

set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}

# TODO: FIXME
# set :git_enable_submodules, true

namespace :deploy do

  desc 'Configura base de dados inicial.'
  task :setup_db do
    on roles(:db) do
      strategy.deploy!
      linka_dependencias
      bundle.install
      run "cd #{release_path} && #{rake} db:create RAILS_ENV=#{rails_env}"
    end
  end

  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :finishing, 'deploy:cleanup'
  after :publishing, 'deploy:migrate'
  after :publishing, 'deploy:restart'
end
