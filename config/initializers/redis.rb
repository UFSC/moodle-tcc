class Redis
  $redis = Redis.new(:host => Settings.redis_host, :port => Settings.redis_port)
end