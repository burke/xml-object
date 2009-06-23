namespace :bm do
  task :dependencies do
    require 'benchmark'

    begin_require_rescue 'xmlsimple', 'to benchmark XmlSimple'
    begin_require_rescue 'libxml',    'to benchmark using LibXML'
  end

  desc 'Benchmarks initial parsing'
  task :new => :dependencies do
    n = 200
    puts "Reading each whole file, #{n} times:"

    Benchmark.bm(34) do |x|

      samples = Dir[File.join(PROJECT_DIR, 'test', 'samples', '*.xml')]
      samples = samples.sort_by { |sample_file| File.size(sample_file) }
      samples = samples.map { |f| File.basename(f, '.xml') }
      padding = samples.map { |s| s.size }.max
      samples.each do |xml_sample|

        begin
          x.report "#{xml_sample.rjust(padding)}.xml: XmlSimple" do
            ::XMLObject.adapter = XmlSimple # Let's be fair

            n.times { XmlSimple.xml_in(open_sample_xml(xml_sample.to_sym)) }
          end
        end if defined?(XmlSimple)

        begin
          require 'adapters/rexml'
          x.report "#{xml_sample.rjust(padding)}.xml: XMLObject (REXML)" do
            ::XMLObject.adapter = ::XMLObject::Adapters::REXML

            n.times { XMLObject.new(open_sample_xml(xml_sample.to_sym)) }
          end
        end

        begin
          require 'adapters/libxml'

          x.report "#{xml_sample.rjust(padding)}.xml: XMLObject (LibXML)" do
            ::XMLObject.adapter = ::XMLObject::Adapters::LibXML

            n.times { XMLObject.new(open_sample_xml(xml_sample.to_sym)) }
          end
        end if defined?(LibXML)

        puts "\n"
      end
    end
  end

  desc 'Benchmarks reading recipe.xml'
  task :recipe => :dependencies do
    n = 50000

    class Recipe
      attr_accessor :name,      :title,    :ingredients, :steps,
                    :prep_time, :cook_time
    end

    Benchmark.bmbm do |x|
      begin
        x.report 'XmlSimple' do
          @xml_simple = XmlSimple.xml_in(open_sample_xml(:recipe))

          n.times do
            recipe       = Recipe.new
            recipe.name  = @xml_simple['name']
            recipe.title = @xml_simple['title'][0]
            recipe.steps = @xml_simple['instructions'][0]['step'].join(', ')
            recipe.prep_time   = @xml_simple['prep_time']
            recipe.cook_time   = @xml_simple['cook_time']
            recipe.ingredients = @xml_simple['ingredient'].collect do |i|
              "#{i['amount']} #{i['unit']} of #{i['content']}"
            end
          end
        end
      end if defined?(XmlSimple)

      begin
        x.report 'XMLObject (singular)' do
          @singular = XMLObject.new(open_sample_xml(:recipe))

          n.times do
            recipe             = Recipe.new
            recipe.name        = @singular.name
            recipe.title       = @singular.title
            recipe.steps       = @singular.instructions.step.join(', ')
            recipe.prep_time   = @singular.prep_time
            recipe.cook_time   = @singular.cook_time
            recipe.ingredients = @singular.ingredients.collect do |i|
              "#{i.amount} #{i.unit} of #{i}"
            end
          end
        end
      end

      begin
        x.report 'XMLObject (plural)' do
          @plural = XMLObject.new(open_sample_xml(:recipe))

          n.times do
            recipe             = Recipe.new
            recipe.name        = @plural.name
            recipe.title       = @plural.title
            recipe.steps       = @plural.instructions.steps.join(', ')
            recipe.prep_time   = @plural.prep_time
            recipe.cook_time   = @plural.cook_time
            recipe.ingredients = @plural.ingredient.collect do |i|
              "#{i.amount} #{i.unit} of #{i}"
            end
          end
        end
      end

      begin
        x.report 'XMLObject (proxy)' do
          @proxy = XMLObject.new(open_sample_xml(:recipe))

          n.times do
            recipe             = Recipe.new
            recipe.name        = @proxy.name
            recipe.title       = @proxy.title
            recipe.steps       = @proxy.instructions.join(', ')
            recipe.prep_time   = @proxy.prep_time
            recipe.cook_time   = @proxy.cook_time
            recipe.ingredients = @proxy.ingredient.collect do |i|
              "#{i.amount} #{i.unit} of #{i}"
            end
          end
        end
      end
    end
  end
end
