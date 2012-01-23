require "capistrano-unicorn-methods/version"
Capistrano::Configuration.instance.load do
  _cset :unicorn_pid, "#{current_release}/tmp/pids/unicorn.pid"
  _cset :unicorn_old_pid, "#{current_release}/tmp/pids/unicorn.pid.oldbin"
  _cset :unicorn_config, "#{current_release}/config/unicorn.rb"
  _cset :unicorn_port, 3000
  _cset :use_bundler, true

  namespace :unicorn do
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
      run "cd #{current_release} ; #{'bundle exec' if use_bundler} unicorn_rails -c #{unicorn_config} -D -p #{unicorn_port}"
    end

    desc "Stop unicorn"
    task :stop do
      run "touch #{unicorn_pid}"
      pid = capture("cat #{unicorn_pid}").to_i
      run "kill -s QUIT #{pid}" if pid > 0
    end

    desc "Cleans up the old unicorn processes"
    task :cleanup do
      run "touch #{unicorn_old_pid}"
      pid = capture("cat #{unicorn_old_pid}").to_i
      run "kill -s QUIT #{pid}" if pid > 0
    end
  end
end
