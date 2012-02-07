Capistrano::Configuration.instance.load do
  namespace :unicorn do

    # Lazy setting these variables, as they (might) depend on other settings
    set(:unicorn_pid)     { "#{current_path}/tmp/pids/unicorn.pid" }
    set(:unicorn_old_pid) { "#{current_path}/tmp/pids/unicorn.pid.oldbin" }
    set(:unicorn_config)  { "#{current_path}/config/unicorn.rb" }
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
      pid = capture("cat #{unicorn_pid}").to_i
      run "kill -s USR2 #{pid}" if pid > 0
    end

    #
    # Starts the unicorn process(es)
    #
    desc "Starts unicorn"
    task :start, :roles => :web do
      logger.info "Starting unicorn server(s).."
      unicorn.cleanup
      run "cd #{current_path} ; #{'bundle exec' if use_bundler} unicorn_rails -c #{unicorn_config} -D -p #{unicorn_port} -E #{rails_env}"
    end

    #
    # This will quit the unicorn process(es).
    #
    # NB! This will not restart the process, to the server(s) will effectively
    # be down!
    #
    desc "Stop unicorn"
    task :stop, :roles => :web do
      logger.info "Stopping unicorn server(s).."
      run "touch #{unicorn_pid}"
      pid = capture("cat #{unicorn_pid}").to_i
      run "kill -s QUIT #{pid}" if pid > 0
    end

    #
    # This will clean up any old unicorn servers left behind by the USR2 kill
    # command.
    #
    desc "Cleans up the old unicorn processes"
    task :cleanup, :roles => :web do
      logger.info "Cleaning out old unicorn server(s).."
      run "touch #{unicorn_old_pid}"
      run "cat #{unicorn_pid} | kill -s QUIT $0}"
      ensure_writable_dirs
    end

    #
    # This will mod the pid dirs to ensure that future pid files can be written
    # to, and read from the dirs.
    #
    # NB! This is only intented for internal usage
    #
    task :ensure_writable_dirs, :role => :web do
      dir = File.dirname(unicorn_pid)
      run "chmod a+w #{dir}"
    end
  end
end
