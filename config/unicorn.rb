app_dir = File.expand_path("../..", __FILE__)
tmp_dir = "#{app_dir}/tmp"
log_dir = "#{app_dir}/log"

working_directory app_dir
worker_processes ENV['UNICORN_WORKERS'] || 2
preload_app true
timeout 30

pid "#{tmp_dir}/pids/unicorn.pid"
listen "#{tmp_dir}/sockets/unicorn.sock", backlog: 64

stderr_path "#{log_dir}/unicorn.stderr.log"
stdout_path "#{log_dir}/unicorn.stdout.log"
