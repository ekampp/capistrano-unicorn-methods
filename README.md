## Usage

1If you don't have one, copy the config/unicorn.rb file into your app in the app/condig/unicorn.rb path. This is the location where the gem will look for the configuration file.

After copying the file you should make sure that all the paths are changed to reflect your system setup.

If you already have a config file you should make sure that the pid file is written to shared/pids/unicorn.pid.

The gem gives you access to the followig methods within the `unicorn.<method>` namespace.

* `unicorn.start` will start the unicorn server in demonized form on port 3000 (default) with the config file placed in app/config/unicorn.rb.
* `unicorn.stop` will stop the unicorn server.
* `unicorn.restart` restarts the unicorn server by moving the old one to <somename>.pid.oldbin and running a `unicorn.cleanup` command.
* `unicorn.cleanup` will remove the master and worker processes associated with the <something>.pid.oldbin file.
