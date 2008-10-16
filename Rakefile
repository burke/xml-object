require 'rake'
require 'rake/testtask'
require File.join(File.dirname(__FILE__), 'lib', 'xml-object')

desc 'Default: run unit tests.'
task :default => :test

desc 'Run the unit tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation'
task :rdoc do
  hanna = File.expand_path File.join(
    File.dirname(__FILE__), 'vendor', 'hanna', 'bin', 'hanna')

  options = [ '--inline-source',
              '--main=README.rdoc',
              '--title="XMLObject"',
              'README.rdoc',
              'lib/xml-object.rb',
              'lib/xml-object/*.rb',
              'lib/xml-object/adapters/*.rb' ]

  ruby_files = File.join File.dirname(__FILE__)

  system "#{hanna} #{options.join(' ')}"
end

desc 'Measures test coverage using rcov'
task :rcov do
  rm_f 'coverage'
  rcov = 'rcov --include lib --exclude /Library/Ruby'
  system "#{rcov} -T #{Dir.glob('test/**/*_test.rb').join(' ')}"
end

desc 'Profiling'
task :profile do
  require 'ruby-prof'

  xml_file = File.join(File.dirname(__FILE__),
    'test', 'samples', 'lorem.xml')

  result = RubyProf.profile do
    XMLObject.new(File.open(xml_file))
  end

  printer = RubyProf::GraphHtmlPrinter.new(result)
  printer.print(File.open('profile.html', 'w'), :min_percent=>0)
  system 'open profile.html' if PLATFORM['darwin']
end

desc 'Silly benchmarks'
task :benchmark do

  require 'benchmark'

  begin
    require 'xmlsimple'
  rescue LoadError
    puts 'XmlSimple not found'
  end

  begin
    require 'hpricot'
  rescue LoadError
    puts 'Hpricot not found'
  end

  xml_file = File.join(File.dirname(__FILE__),
    'test', 'samples', 'recipe.xml')

  puts "Reading whole file:"
  n = 500
  Benchmark.bm(20) do |x|
    x.report "REXML:" do
      n.times { recipe = REXML::Document.new(File.open(xml_file)) }
    end

    require File.join(File.dirname(__FILE__), 'lib', 'xml-object',
      'adapters', 'rexml')
    XMLObject.adapter = XMLObject::Adapters::REXML
    x.report("XMLObject (REXML):") do
      n.times { recipe = XMLObject.new(File.open(xml_file)) }
    end

    if defined?(Hpricot)
      require File.join(File.dirname(__FILE__), 'lib', 'xml-object',
        'adapters', 'hpricot')
      XMLObject.adapter = XMLObject::Adapters::Hpricot
      x.report("XMLObject (Hpricot):") do
        n.times { recipe = XMLObject.new(File.open(xml_file)) }
      end
    end

    if defined?(XmlSimple)
      x.report "XmlSimple:" do
        n.times { recipe = XmlSimple.xml_in(File.open(xml_file)) }
      end
    end
  end
end
