require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require File.join(File.dirname(__FILE__), 'lib', 'xml_struct')

desc 'Default: run unit tests.'
task :default => :test

desc 'Run the unit tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'XMLStruct'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include 'README.markdown'
  rdoc.rdoc_files.include 'lib/**/*.rb'
end

desc 'Measures test coverage using rcov'
task :rcov do
  rm_f 'coverage'
  rm_f 'coverage.data'

  rcov = %{ rcov --aggregate coverage.data --text-summary
    --include lib
    --exclude /Library/Ruby
  }.strip!.gsub! /\s+/, ' '

  system("#{rcov} --html #{Dir.glob('test/**/*_test.rb').join(' ')}")
  system('open coverage/index.html') if PLATFORM['darwin']
end

desc 'Profiling'
task :profile do
  require 'ruby-prof'

  xml_file = File.join(File.dirname(__FILE__),
    'test', 'samples', 'lorem.xml')

  result = RubyProf.profile do
    XMLStruct.new(File.open(xml_file))
  end

  printer = RubyProf::GraphHtmlPrinter.new(result)
  printer.print(File.open('profile.html', 'w'), :min_percent=>0)
  system('open profile.html') if PLATFORM['darwin']
end
