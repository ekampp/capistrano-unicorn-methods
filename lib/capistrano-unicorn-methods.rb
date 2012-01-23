require "capistrano-unicorn-methods/version"
Capistrano::Configuration.instance.load do
  namespace :unicorn do
    desc "Zero-downtime restart of Unicorn"
    task :restart, :except => { :no_release => true } do
      unicorn.cleanup
      run "touch #{current_release}/tmp/pids/unicorn.pid"
      pid = capture("cat #{current_release}/tmp/pids/unicorn.pid").to_i
      run "kill -s USR2 #{pid}" if pid > 0
    end

    desc "Starts unicorn"
    task :start, :except => { :no_release => true } do
      unicorn.cleanup
      run "cd #{current_release} ; bundle exec unicorn_rails -c #{current_release}/config/unicorn.rb -D -p 3000"
    end

    desc "Stop unicorn"
    task :stop, :except => { :no_release => true } do
      run "touch #{current_release}/tmp/pids/unicorn.pid"
      pid = capture("cat #{current_release}/tmp/pids/unicorn.pid").to_i
      run "kill -s QUIT #{pid}" if pid > 0
    end

    desc "Cleans up the old unicorn processes"
    task :cleanup do
      run "touch #{current_release}/tmp/pids/unicorn.pid.oldbin"
      pid = capture("cat #{current_release}/tmp/pids/unicorn.pid.oldbin").to_i
      run "kill -s QUIT #{pid}" if pid > 0
    end
  end
end
