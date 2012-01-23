## Usage

The gem gives you access to the followig methods within the `unicorn.<method>` namespace.

* `unicorn.start` will start the unicorn server in demonized form on port 3000 (default) with the config file placed in app/config/unicorn.rb.
* `unicorn.stop` will stop the unicorn server.
* `unicorn.restart` restarts the unicorn server by moving the old one to <somename>.pid.oldbin and running a `unicorn.cleanup` command.
* `unicorn.cleanup` will remove the master and worker processes associated with the <something>.pid.oldbin file.

## Requirements

This gem requires a couple of other gems and config files:

* `unicorn`

## Customization

You can customize the gems behavior by setting any (or all) of the following options within capistrano's configuration:

* `unicorn_pid` indicates the path for the pid file. Defaults to shared/pids/unicorn.pid.
* `unicorn_old_pid` contains the pid for the old server. Defaults to shared/pids/unicorn.pid.oldbin.
* `unicorn_config` the path to the unicorn config file. Defaults to /path/to/your/app/config/unicorn.rb.
* `unicorn_port` defines the port that unicorn should listen on. Defaults to 3000.
