# code from https://gist.github.com/muxcmux/1805946
require 'modules/version'

include Version

desc "Prints the current application version"
version = Version.read_version
task :version do
  puts <<HELP
Available commands are:
-----------------------
rake version:write[version]       # set custom version in the x.x.x-? format
rake version:patch                # increment the patch x.x.x+1 (keeps any flags on)
rake version:minor                # increment minor and reset patch x.x+1.0 (keeps any flags on)
rake version:major                # increment major and reset others x+1.0.0 (keeps any flags on)
rake version:dev                  # set the dev flag on x.x.x-dev
rake version:beta                 # set the beta flag on x.x.x-beta
rake version:rc                   # set or increment the rc flag x.x.x-rcX
rake version:release              # removes any flags from the current version
rake version:current              # get the current application version
rake version:current:hash[count]  # get the hash for current application version, count equal zero (empty) for all

HELP
  puts "Current version is: #{version}"
end

namespace :version do

  desc "Write version explicitly by specifying version number as a parameter"
  task :write, [:version] => :environment do |t, args|
    #puts "args[:version] = #{args}"
    Version.write_version args[:version].strip
    puts "Version explicitly written: #{Version.read_version}"
  end

  desc "Increments the patch version"
  task :patch do
    new_version = Version.increment Version.read_version, 2
    Version.write_version new_version
    puts "Application patched: #{new_version}"
  end

  desc "Increments the minor version and resets the patch"
  task :minor do
    incremented = Version.increment Version.read_version, 1
    new_version = Version.reset incremented, [2]
    Version.write_version new_version
    puts "New version released: #{new_version}"
  end

  desc "Increments the major version and resets both minor and patch"
  task :major do
    incremented = Version.increment Version.read_version, 0
    new_version = Version.reset incremented, [1, 2]
    Version.write_version new_version
    puts "Major application version change: #{new_version}. Congratulations!"
  end

  desc "Sets the development flag on"
  task :dev do
    version, flag = Version.read_version.split '-'
    new_version = [version, 'dev'].join '-'
    Version.write_version new_version
    puts "Version in development: #{new_version}"
  end

  desc "Sets the beta flag on"
  task :beta do
    version, flag = Version.read_version.split '-'
    new_version = [version, 'beta'].join '-'
    Version.write_version new_version
    puts "Version in beta: #{new_version}"
  end

  desc "Sets or increments the rc flag"
  task :rc do
    version, flag = Version.read_version.split '-'
    rc = /^rc(\d+)$/.match flag
    if rc
      new_version = [version, "rc#{rc[1].to_i+1}"].join '-'
    else
      new_version = [version, 'rc1'].join '-'
    end
    Version.write_version new_version
    puts "New version release candidate: #{new_version}"
  end

  desc "Removes any version flags"
  task :release do
    version, flag = Version.read_version.split '-'
    Version.write_version version
    puts "Released stable version: #{version}"
  end

  desc "Gets the current application version"
  task :current do
    puts "#{version}"
  end

  namespace :current do
    desc "Gets the current application version and git commit hash"
    task :hash, [:count] do | t, args |
      puts Version.read_version_hash args[:count].present? ? args[:count].to_i : 0
    end

  end
end