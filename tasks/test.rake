require 'rake/testtask'

task :default => :test

desc 'Run the specification tests'
task :test do
  ruby "#{PROJECT_DIR}/vendor/bacon/bin/bacon " +
       "#{PROJECT_DIR}/test/*_test.rb"
end
