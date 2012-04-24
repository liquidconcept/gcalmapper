#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'yard'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = [
    '--title',   'gcalMapper',
    '--markup',  'markdown',
    '--charset', 'UTF-8',
    '--protected',
    '--private'
  ]
end

if RUBY_VERSION =~ /^1\.9/
  desc "Code coverage detail"
  task :simplecov do
    ENV['COVERAGE'] = "true"
    Rake::Task['spec'].execute
  end
end