namespace :test do
  task :run_all do
    puts "Running all tests.."
  end
end
task :default => 'test:run_all'
