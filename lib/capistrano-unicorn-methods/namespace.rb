Capistrano::Configuration.instance.load do
  namespace :unicorn do

    # Lazy setting these variables, as they (might) depend on other settings
    set(:unicorn_pid)     { "#{current_path}/tmp/pids/unicorn.pid" }
    set(:unicorn_old_pid) { "#{current_path}/tmp/pids/unicorn.pid.oldbin" }
    set(:unicorn_config)  { "#{current_path}/config/unicorn.rb" }
    set(:unicorn_port)    { 3000 }
    set(:use_bundler)     { true }
    set(:rails_env)       { "production" }

    desc "Zero-downtime restart of Unicorn"
    task :restart do
      unicorn.cleanup
      run "touch #{unicorn_pid}"
      pid = capture("cat #{unicorn_pid}").to_i
      run "kill -s USR2 #{pid}" if pid > 0
    end

    desc "Starts unicorn"
    task :start, :roles => :app do
      logger.info "Starting unicorn server(s).."
      unicorn.cleanup
      run "cd #{current_path} ; #{'bundle exec' if use_bundler} unicorn_rails -c #{unicorn_config} -D -p #{unicorn_port} -E #{rails_env}"
    end

    desc "Stop unicorn"
    task :stop, :roles => :app do
      logger.info "Stopping unicorn server(s).."
      run "touch #{unicorn_pid}"
      pid = capture("cat #{unicorn_pid}").to_i
      run "kill -s QUIT #{pid}" if pid > 0
    end

    desc "Cleans up the old unicorn processes"
    task :cleanup, :roles => :app do
      logger.info "Cleaning out old unicorn server(s).."
      run "touch #{unicorn_old_pid}"
      pid = capture("cat #{unicorn_old_pid}").to_i
      run "kill -s QUIT #{pid}" if pid > 0
      ensure_writable_dirs
    end

    task :ensure_writable_dirs, :role => :app do
      dir = File.dirname(unicorn_pid)
      run "chmod a+w #{dir}"
    end
  end
end
