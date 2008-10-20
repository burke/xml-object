namespace :perf do

  namespace :profile do
    task(:load_hpricot) { require('adapters/hpricot') }

    task :run do
      require 'ruby-prof'

      xml_file = File.join(PROJECT_DIR, 'test', 'samples', 'lorem.xml')

      result = RubyProf.profile do
        xml_obj = XMLObject.new(File.open(xml_file))

        xml_obj.consecteturs.collect { |c| c.capacity }
        xml_obj.name.upcase
        xml_obj.sed.do.price
      end

      adapter  = XMLObject.adapter.to_s.split('::').last.downcase
      filename = File.join(PROJECT_DIR, "profile_with_#{adapter}.html")
      printer  = RubyProf::GraphHtmlPrinter.new(result)

      printer.print(File.open(filename, 'w'), :min_percent => 10)
      system "open #{filename}" if PLATFORM.match('darwin')

      puts "Dumped in #{filename}"
    end

    desc 'Profiles the opening of lorem.xml using REXML'
    task :rexml => :run

    desc 'Profiles the opening of lorem.xml using Hpricot'
    task :hpricot => [ :load_hpricot, :run ]
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

    xml_file = File.join(PROJECT_DIR, 'test', 'samples', 'recipe.xml')

    puts "Reading whole file:"
    n = 500
    Benchmark.bm(20) do |x|
      x.report "REXML:" do
        n.times { recipe = REXML::Document.new(File.open(xml_file)) }
      end

      require 'xml-object/adapters/rexml'
      XMLObject.adapter = XMLObject::Adapters::REXML
      x.report("XMLObject (REXML):") do
        n.times { recipe = XMLObject.new(File.open(xml_file)) }
      end

      if defined?(Hpricot)
        require 'adapters/hpricot'
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