require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Validate by robocop'
task :rubocop do
  sh 'rubocop -D'
end

