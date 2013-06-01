#
listen 3131
worker_processes 4
pid "#{File.expand_path('.')}/tmp/pids/unicorn.pid" 
stderr_path "#{File.expand_path('.')}/log/unicorn.log" 
stdout_path "#{File.expand_path('.')}/log/unicorn.log" 
#
preload_app true
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end