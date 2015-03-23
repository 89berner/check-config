# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = "/opt/check-config/"

worker_processes 5
working_directory @dir

timeout 600

# Specify path to socket unicorn listens to,
# we will use this in our nginx.conf later
listen "#{@dir}/unicorn.sock", :backlog => 100

# Set process id path
pid "#{@dir}/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}/unicorn.stderr.log"
stdout_path "#{@dir}/unicorn.stdout.log"
