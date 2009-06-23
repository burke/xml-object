begin
  require 'hanna/rdoctask'
rescue LoadError
  require 'rake/rdoctask'
end

namespace :rdoc do
  desc 'Generate documentation using RDoc'
  Rake::RDocTask.new(:run) do |rdoc|
    rdoc.rdoc_files.include(
      'README.rdoc', 'MIT-LICENSE', 'WHATSNEW', 'lib/**/*.rb')

    rdoc.main      = 'README.rdoc'
    rdoc.title     = 'XMLObject'
    rdoc.rdoc_dir  = 'doc'
    rdoc.options  << '--inline-source'
  end
end

desc '=> rdoc:run'
task :rdoc => 'rdoc:run'