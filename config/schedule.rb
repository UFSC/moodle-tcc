# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, 'log/sync-cron.log'
job_type :rake, 'cd :path && PATH=/usr/local/bin:$PATH RAILS_ENV=:environment bin/rake :task :output'

# CRONTAB da produção
if @stage == 'production'
  every 1.hour do
    rake 'tcc:sync'
  end
end

# CRONTAB do staging
if @stage == 'staging'
  every 6.hour do
    rake 'tcc:sync'
  end
end