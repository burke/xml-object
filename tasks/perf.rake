namespace :perf do

  desc 'Profiles the opening of lorem.xml'
  task :profile do
    require 'ruby-prof'

    xml_file = File.join(PROJECT_ROOT, 'spec', 'samples', 'lorem.xml')
    result   = RubyProf.profile do
      XMLObject.new(File.open(xml_file))
    end

    result_filename = File.join(PROJECT_ROOT, 'profile.html')

    printer = RubyProf::GraphHtmlPrinter.new(result)
    printer.print(File.open(result_filename, 'w'), :min_percent=>0)
    system "open #{result_filename}" if PLATFORM['darwin']
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

    xml_file = File.join(PROJECT_ROOT, 'spec', 'samples', 'recipe.xml')

    puts "Reading whole file:"
    n = 500
    Benchmark.bm(20) do |x|
      x.report "REXML:" do
        n.times { recipe = REXML::Document.new(File.open(xml_file)) }
      end

      require File.join(PROJECT_ROOT, 'lib', 'xml-object',
        'adapters', 'rexml')
      XMLObject.adapter = XMLObject::Adapters::REXML
      x.report("XMLObject (REXML):") do
        n.times { recipe = XMLObject.new(File.open(xml_file)) }
      end

      if defined?(Hpricot)
        require File.join(PROJECT_ROOT, 'lib', 'xml-object',
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
end