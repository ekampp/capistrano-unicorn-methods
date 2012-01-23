require "capistrano-unicorn-methods/version"
Capistrano::Configuration.instance.load do
  _cset :unicorn_pid, "#{current_release}/tmp/pids/unicorn.pid"
  _cset :unicorn_old_pid, "#{current_release}/tmp/pids/unicorn.pid.oldbin"
  _cset :unicorn_config, "#{current_release}/config/unicorn.rb"
  _cset :unicorn_port, 3000

  namespace :unicorn do
    desc "Zero-downtime restart of Unicorn"
    task :restart, :except => { :no_release => true } do
      unicorn.cleanup
      run "touch #{unicorn_pid}"
      pid = capture("cat #{unicorn_pid}").to_i
      run "kill -s USR2 #{pid}" if pid > 0
    end

    desc "Starts unicorn"
    task :start, :except => { :no_release => true } do
      unicorn.cleanup
      run "cd #{current_release} ; bundle exec unicorn_rails -c #{unicorn_config} -D -p #{unicorn_port}"
    end

    desc "Stop unicorn"
    task :stop, :except => { :no_release => true } do
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
