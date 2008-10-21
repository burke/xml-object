namespace :perf do

  namespace :profile do
    task(:load_hpricot) { require('adapters/hpricot') }
    task(:load_libxml)  { require('adapters/libxml')  }

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

    desc 'Profiles the opening of lorem.xml using LibXML'
    task :libxml => [ :load_libxml, :run ]
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

    if defined?(JRUBY_VERSION)
      begin
        require 'jrexml'
      rescue LoadError
        puts 'LibXML not found'
      end
    else
      begin
        require 'libxml'
      rescue LoadError
        puts 'LibXML not found'
      end
    end

    xml_file = File.join(PROJECT_DIR, 'test', 'samples', 'recipe.xml')

    n = 500
    platform = if defined?(JRUBY_VERSION)
      "Ruby #{RUBY_VERSION} (JRuby #{JRUBY_VERSION})"
    else
      "Ruby #{RUBY_VERSION} (MRI)"
    end

    puts "XMLObject benchmark under #{platform}"
    puts "Reading whole file, #{n} times:"
    Benchmark.bmbm do |x|
      x.report 'REXML (alone):' do
        n.times { rexml_alone = REXML::Document.new(File.open(xml_file)) }
      end

      if defined?(XmlSimple)
        x.report 'XmlSimple:' do
          n.times { xml_simple = XmlSimple.xml_in(File.open(xml_file)) }
        end
      end

      x.report('XMLObject (REXML):') do
        require 'adapters/rexml'
        ::XMLObject.adapter = ::XMLObject::Adapters::REXML
        n.times { rexml = XMLObject.new(File.open(xml_file)) }
      end

      if defined?(Hpricot)
        x.report('XMLObject (Hpricot):') do
          require 'adapters/hpricot'
          ::XMLObject.adapter = ::XMLObject::Adapters::Hpricot
          n.times { hpricot = XMLObject.new(File.open(xml_file)) }
        end
      end

      if defined?(LibXML)
        x.report('XMLObject (LibXML):') do
          require 'adapters/libxml'
          ::XMLObject.adapter = ::XMLObject::Adapters::LibXML
          n.times { libxml = XMLObject.new(File.open(xml_file)) }
        end
      end

      if defined?(JREXML)
        x.report('XMLObject (JREXML):') do
          require 'adapters/jrexml'
          ::XMLObject.adapter = ::XMLObject::Adapters::JREXML
          n.times { jrexml = XMLObject.new(File.open(xml_file)) }
        end
      end
    end
  end
end