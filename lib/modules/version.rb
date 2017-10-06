module Version

  def Version.valid? version
    pattern = /^\d+\.\d+\.\d+(\-(dev|beta|rc\d+))?$/
    raise "Tried to set invalid version: #{version}" unless version =~ pattern
  end

  def Version.correct_version version
    ver, flag = version.split '-'
    v = ver.split '.'
    (0..2).each do |n|
      v[n] = v[n].to_i
    end
    [v.join('.'), flag].compact.join '-'
  end

  def Version.read_version
    begin
      File.read 'VERSION'
    rescue
      raise "VERSION file not found or unreadable."
    end
  end

  def Version.read_version_hash count = 0
    version = Version.read_version
    # REVISION file is used for Capistrano on Server file system structure to identify the repository revision
    if File.exist?('REVISION')
      hash = File.read('REVISION')
    else
      hash = `git rev-parse --verify HEAD`.gsub(/\n/,'')
    end
    hash = hash[0..count] if count > 0
    result = "#{version}_#{hash}"
    result
  end

  def Version.get_branch
    # REVISION file is used for Capistrano on Server file system structure to identify the repository revision
    if File.exist?('REVISION')
      branch = ''
    else
      branch = `git symbolic-ref -q HEAD`.gsub(/\n/,'')
    end
    branch
  end

  def Version.write_version version
    valid? version
    begin
      File.open 'VERSION', 'w' do |file|
        file.write correct_version(version)
      end
    rescue
      raise "VERSION file not found or unwritable."
    end
  end

  def Version.reset current, which
    version, flag = current.split '-'
    v = version.split '.'
    which.each do |part|
      v[part] = 0
    end
    [v.join('.'), flag].compact.join '-'
  end

  def Version.increment current, which
    version, flag = current.split '-'
    v = version.split '.'
    v[which] = v[which].to_i + 1
    [v.join('.'), flag].compact.join '-'
  end

end