# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capistrano-unicorn-methods/version"

Gem::Specification.new do |s|
  s.name        = "capistrano-unicorn-methods"
  s.version     = Capistrano::Unicorn::Methods::VERSION
  s.authors     = ["Emil Kampp"]
  s.email       = ["emiltk@benjamin.dk"]
  s.homepage    = "http://emil.kampp.me"
  s.summary     = %q{Contains standadized methods for managing unicorn servers through capistrano.}
  s.description = %q{Contains a unicorn namespace with methods for starting stopping and maintaining the unicorn server to serve the rails app.}

  s.rubyforge_project = "capistrano-unicorn-methods"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
