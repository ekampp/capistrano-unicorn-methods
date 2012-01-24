require "capistrano-unicorn-methods/version"
Capistrano::Configuration.instance.load do
  namespace :unicorn do

    # Lazy setting these variables, as they (might) depend on other settings
    set(:unicorn_pid)     { fetch(:current_path)+"/tmp/pids/unicorn.pid" }
    set(:unicorn_old_pid) { fetch(:current_path)+"/tmp/pids/unicorn.pid.oldbin" }
    set(:unicorn_config)  { fetch(:current_path)+"/config/unicorn.rb" }
    set(:unicorn_port)    { 3000 }
    set(:use_bundler)     { true }

    desc "Zero-downtime restart of Unicorn"
    task :restart do
      unicorn.cleanup
      run "touch #{unicorn_pid}"
      pid = capture("cat #{unicorn_pid}").to_i
      run "kill -s USR2 #{pid}" if pid > 0
    end

    desc "Starts unicorn"
    task :start do
      unicorn.cleanup
      run "cd #{current_path} ; #{'bundle exec' if use_bundler} unicorn_rails -c #{unicorn_config} -D -p #{unicorn_port}"
    end

    desc "Stop unicorn"
    task :stop do
      run "touch #{unicorn_pid}"
      pid = capture("cat #{unicorn_pid}").to_i
      run "kill -s QUIT #{pid}" if pid > 0
    end

    desc "Cleans up the old unicorn processes"
    task :cleanup do

      puts "Cleaning up: \n\n#{unicorn_pid}\n"

      run "touch #{unicorn_old_pid}"
      pid = capture("cat #{unicorn_old_pid}").to_i
      run "kill -s QUIT #{pid}" if pid > 0
    end
  end
end
