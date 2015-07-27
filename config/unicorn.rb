@dir = (File.expand_path(File.dirname(__FILE__), './').gsub! /\/config/, '') + '/'

worker_processes 2
working_directory @dir

timeout 30

# Specify path to socket unicorn listens to,
# we will use this in our nginx.conf later
listen "#{@dir}tmp/unicorn.sock", :backlog => 64

# Set process id path
pid "#{@dir}tmp/unicorn.pid"

# Set log file paths
# stderr_path "#{@dir}log/unicorn.stderr.log"
# stdout_path "#{@dir}log/unicorn.stdout.log"