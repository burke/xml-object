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

  namespace :benchmark do
    task :require_dependencies do

      require 'benchmark'

      begin_require_rescue 'xmlsimple', 'to benchmark XmlSimple'
      begin_require_rescue 'hpricot',   'to benchmark using Hpricot'

      if defined?(JRUBY_VERSION)
        begin_require_rescue 'jrexml', 'to benchmark using JREXML'
      else
        begin_require_rescue 'libxml', 'to benchmark using LibXML'
      end
    end

    desc 'Measures initial parsing performance'
    task :initial_parsing => :require_dependencies do
      n = 500

      puts "Benchmark initial parsing"
      puts "Reading whole file, #{n} times:"
      Benchmark.bmbm do |x|

        begin
          x.report 'XmlSimple:' do
            ::XMLObject.adapter = XmlSimple # Let's be fair

            n.times { XmlSimple.xml_in(open_sample_xml(:recipe)) }
          end
        end if defined?(XmlSimple)

        begin
          require 'adapters/rexml'
          x.report('XMLObject (REXML):') do
            ::XMLObject.adapter = ::XMLObject::Adapters::REXML

            n.times { XMLObject.new(open_sample_xml(:recipe)) }
          end
        end

        begin
          require 'adapters/hpricot'

          x.report('XMLObject (Hpricot):') do
            ::XMLObject.adapter = ::XMLObject::Adapters::Hpricot

            n.times { XMLObject.new(open_sample_xml(:recipe)) }
          end
        end if defined?(Hpricot)

        begin
          require 'adapters/libxml'

          x.report('XMLObject (LibXML):') do
            ::XMLObject.adapter = ::XMLObject::Adapters::LibXML

            n.times { XMLObject.new(open_sample_xml(:recipe)) }
          end
        end if defined?(LibXML)

        begin
          require 'adapters/jrexml'

          x.report('XMLObject (JREXML):') do
            ::XMLObject.adapter = ::XMLObject::Adapters::JREXML

            n.times { XMLObject.new(open_sample_xml(:recipe)) }
          end
        end if defined?(JREXML)
      end
    end

    desc 'Measures array iterating overhead'
    task :iteration => :require_dependencies do
      n = 150000

      puts "Benchmarking iteration overhead"
      puts "Iterating over instructions, #{n} times:"
      Benchmark.bmbm do |x|

        begin
          steps ||= [
            'Mix all ingredients together.',
            'Knead thoroughly.',
            'Cover with a cloth, and leave for one hour in warm room.',
            'Knead again.',
            'Place in a bread baking tin.',
            'Cover with a cloth, and leave for one hour in warm room.',
            'Bake in the oven at 180(degrees)C for 30 minutes.'
          ]

          unless 'Knead again.' == steps[3]
            raise 'Steps not read correctly'
          end

          x.report 'Baseline' do
            steps.each do |s|
              n.times { s.upcase.size }
            end
          end
        end

        begin
          simple ||= XmlSimple.xml_in(open_sample_xml(:recipe))

          unless 7 == simple['instructions'][0]['step'].size
            raise 'Steps not read correctly'
          end

          x.report 'XmlSimple (no opts):' do
            simple['instructions'][0]['step'].each do |s|
              n.times { s.upcase.size }
            end
          end
        end if defined?(XmlSimple)

        begin
          singular ||= XMLObject.new(open_sample_xml(:recipe))

          unless 7 == singular.instructions.step.size
            raise 'Steps not read correctly'
          end

          x.report('XMLObject (singular array):') do
            singular.instructions.step.each do |s|
              n.times { s.upcase.size }
            end
          end
        end

        begin
          plural ||= XMLObject.new(open_sample_xml(:recipe))

          unless 7 == plural.instructions.step.size
            raise 'Steps not read correctly'
          end

          x.report('XMLObject (plural array):') do
            plural.instructions.steps.each do |s|
              n.times { s.upcase.size }
            end
          end
        end

        begin
          proxy ||= XMLObject.new(open_sample_xml(:recipe))

          unless 7 == proxy.instructions.step.size
            raise 'Steps not read correctly'
          end

          x.report('XMLObject (collection proxy):') do
            proxy.instructions.each do |s|
              n.times { s.upcase.size }
            end
          end
        end
      end
    end
  end
end