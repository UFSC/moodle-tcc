# Figure out the name of the current local branch
def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  puts "Deploying branch #{branch}"
  branch
end

set :deploy_to, '/home/gabriel/tcc.labsoft.ufsc.br'
set :branch, current_git_branch