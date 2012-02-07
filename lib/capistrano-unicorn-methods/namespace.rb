Capistrano::Configuration.instance.load do
  namespace :unicorn do

    # Lazy setting these variables, as they (might) depend on other settings
    set(:unicorn_pid)     { "#{current_path}/tmp/pids/unicorn.pid" }
    set(:unicorn_old_pid) { "#{current_path}/tmp/pids/unicorn.pid.oldbin" }
    set(:unicorn_config)  { "#{current_path}/config/unicorn.rb" }
    set(:unicorn_socket)  { "#{shared_path}/system/unicorn.sock" }
    set(:unicorn_port)    { 3000 }
    set(:use_bundler)     { true }
    set(:rails_env)       { "production" }

    #
    # Restarts the unicorn process(es) with the URS2 code, to gracefully
    # create a new server, and kill of the old one, leaving *no* downtime
    #
    desc "Zero-downtime restart of Unicorn"
    task :restart do
      unicorn.cleanup
      run "touch #{unicorn_pid}"
      find_servers(:roles => :app).each do |server|
        pid = capture "cat #{unicorn_pid}", :hosts => [server]
        run "kill -s USR2 #{pid.to_i}", :hosts => [server] if pid.to_i > 0
      end
    end

    #
    # Starts the unicorn process(es)
    #
    desc "Starts unicorn"
    task :start, :roles => :app do
      unicorn.cleanup
      start_without_cleanup
    end

    #
    # Starts the unicorn servers
    desc "Starts the unicorn server without cleaning up from the previous instance"
    task :start_without_cleanup, :roles => :app do
      logger.info "Starting unicorn server(s).."
      run "cd #{current_path}; #{'bundle exec' if use_bundler} unicorn_rails -c #{unicorn_config} -D#{" -p #{unicorn_port}" if unicorn_port} -E #{rails_env}"
    end

    #
    # This will quit the unicorn process(es).
    #
    # NB! This will not restart the process, to the server(s) will effectively
    # be down!
    #
    desc "Stop unicorn"
    task :stop, :roles => :app do
      logger.info "Stopping unicorn server(s).."
      run "touch #{unicorn_pid}"
      find_servers(:roles => :app).each do |server|
        pid = capture "cat #{unicorn_pid}", :hosts => [server]
        run "kill -s QUIT #{pid.to_i}", :hosts => [server] if pid.to_i > 0
      end
    end

    #
    # This will clean up any old unicorn servers left behind by the USR2 kill
    # command.
    #
    desc "Cleans up the old unicorn processes"
    task :cleanup, :roles => :app do
      logger.info "Cleaning out old unicorn server(s).."
      run "touch #{unicorn_old_pid}"
      find_servers(:roles => :app).each do |server|
        pid = capture "cat #{unicorn_old_pid}", :hosts => [server]
        run "kill -s QUIT #{pid.to_i}", :hosts => [server] if pid.to_i > 0
      end
      ensure_writable_dirs
    end

    #
    # This will mod the pid dirs to ensure that future pid files can be written
    # to, and read from the dirs.
    #
    # NB! This is only intented for internal usage
    #
    task :ensure_writable_dirs, :role => :app do
      dir = File.dirname(unicorn_pid)
      run "chmod a+w #{dir}"
    end
  end
end
