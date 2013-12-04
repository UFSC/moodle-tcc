# Figure out the name of the current local branch
def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  puts "Deploying branch #{branch}"
  branch
end

set :user, 'deploy'
set :deploy_to, '/home/deploy/tcc.teste-moodle.ufsc.br'
set :branch, current_git_branch

role :web, 'tcc.teste-moodle.ufsc.br'                          # Your HTTP server, Apache/etc
role :app, 'tcc.teste-moodle.ufsc.br'                          # This may be the same as your `Web` server
role :db,  'tcc.teste-moodle.ufsc.br', :primary => true        # This is where Rails migrations will run

# Verificação de dependências
shared_files = %w(database.yml moodle.yml tcc_config.yml errbit.yml email.yml)
shared_files.each do |rfile|
    depend :remote, :file, File.join(deploy_to, 'shared', rfile)
end

shared_folders = %w(uploads)
shared_folders.each do |rfolder|
    depend :remote, :directory, File.join(deploy_to, 'shared', rfolder)
end
