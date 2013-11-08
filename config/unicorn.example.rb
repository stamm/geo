app_path = '/var/www/rails/geo'


APP_ROOT = "#{app_path}/current"
SHARED_ROOT = "#{app_path}/shared"

worker_processes ENV['COUNT'] || 2
timeout ENV['TIMEOUT'] || 3
working_directory APP_ROOT
#listen "#{APP_ROOT}/tmp/pids/unicorn.sock", backlog: 2048
listen 3000
pid "#{APP_ROOT}/tmp/pids/unicorn.pid"
stderr_path "#{APP_ROOT}/log/unicorn.stderr.log"
stdout_path "#{APP_ROOT}/log/unicorn.stdout.log"

preload_app true

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)


before_fork do |server, worker|

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  sleep 1
end

after_fork do |server, worker|

end