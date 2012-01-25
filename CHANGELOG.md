## v. 0.0.6: Loading issues

You should now require the gem, and then load the methods into capistrano with `::CapistranoUnicornMethods.load`.

## v 0.0.5: Writable pid dir

Ensures that everybody can write to the pid dir

## v 0.0.4: Rails environment

Added the -E option when starting unicorn. This will use the `rails_env` variable or default to 'production'.

## v 0.0.3: Lazy loading

Added lazy loading to allow multistage

## v 0.0.1: Initial release.

This contains the initial release of the namespace.
