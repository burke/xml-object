require 'rake'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  # if rubygems is being used to manage $:, require it in the tests too
  t.ruby_opts += [ '-rubygems' ] if defined?(::Gem)

  t.libs    = ['.'] if ENV['NO_LIB']
  t.pattern = 'test/*_test.rb'
  t.verbose = true
  t.warning = false
end