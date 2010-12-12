def log_to(stream)
  ActiveRecord::Base.logger = Logger.new(stream)
  ActiveRecord::Base.clear_active_connections!
end

def trace(msg = "trace")
  start = Time.now
  yield
ensure
  diff = Time.now - start
  puts "%s: %f" % [msg, diff]
  diff
end