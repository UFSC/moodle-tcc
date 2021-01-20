class Redis
  begin
    @redis_password = Settings.redis_pass
  rescue
    @redis_password = ''
  end
  $redis = Redis.new(:host => Settings.redis_host,
                     :port => Settings. redis_port,
                     :password => @redis_password)
end