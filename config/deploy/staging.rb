# Figure out the name of the current local branch
def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  puts "Deploying branch #{branch}"
  branch
end

set :deploy_to, '/home/gabriel/tcc.labsoft.ufsc.br'
set :branch, current_git_branch

# Verificação de dependências
shared_files = %w(database.yml moodle.yml tcc_config.yml errbit.yml email.yml)
shared_files.each do |rfile|
    depend :remote, :file, File.join(deploy_to, 'shared', rfile)
end

shared_folders = %w(uploads)
shared_folders.each do |rfolder|
    depend :remote, :directory, File.join(deploy_to, 'shared', rfolder)
end