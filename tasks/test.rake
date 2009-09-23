require 'rake/testtask'

task :default => :test

desc 'Run the specification tests'
task :test do
  bacon      = XMLObject::Helper.dir.join('vendor', 'bacon', 'bin', 'bacon')
  test_files = XMLObject::Helper.dir.join('test', '*_test.rb')
  rubygems   = defined?(::Gem) ? '-rubygems' : ''

  ruby "#{rubygems} #{bacon} -q #{test_files}"
end