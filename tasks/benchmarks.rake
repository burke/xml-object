namespace :bm do
  task :dependencies do
    require 'benchmark'

    %w[ xmlsimple libxml ].each do |library|
      begin; require library; rescue LoadError; nil; end
    end

    unless defined? XmlSimple
      puts "  ** Install 'xmlsimple' to benchmark XmlSimple"
    end

    unless defined?(LibXML) || defined?(JRUBY_VERSION)
      puts "  ** Install 'libxml-ruby' to benchmark using LibXML"
    end
  end

  desc 'Benchmarks initial parsing'
  task :new => :dependencies do
    n = 200
    puts "Reading each whole file, #{n} times:"

    Benchmark.bm(35) do |x|
      samples = FileList[File.dirname(__FILE__) + '/benchmarks/*.xml']
      samples = samples.sort_by { |sample_file| File.size(sample_file) }
      padding = samples.map { |s| File.basename(s).size + 1 }.max
      samples.each do |sample_file|
        begin
          report_name = File.basename(sample_file).rjust(padding)
          sample_xml  = File.read(sample_file)
          x.report " #{report_name}: XmlSimple" do
            n.times { XmlSimple.xml_in(sample_xml) }
          end
        end if defined?(XmlSimple)

        begin
          require 'xml-object/adapters/rexml'
          report_name = File.basename(sample_file).rjust(padding)
          sample_xml  = File.read(sample_file)
          x.report " #{report_name}: XMLObject (REXML)" do
            ::XMLObject.adapter = ::XMLObject::Adapters::REXML

            n.times { XMLObject.new(sample_xml) }
          end
        end

        begin
          require 'xml-object/adapters/libxml'
          report_name = File.basename(sample_file).rjust(padding)
          sample_xml  = File.read(sample_file)
          x.report " #{report_name}: XMLObject (LibXML)" do
            ::XMLObject.adapter = ::XMLObject::Adapters::LibXML

            n.times { XMLObject.new(sample_xml) }
          end
        end if defined?(LibXML)

        puts
      end
    end
  end

  desc 'Benchmarks object access to recipe.xml'
  task :recipe => :dependencies do
    n = 50000

    class Recipe
      attr_accessor :name,      :title,    :ingredients, :steps,
                    :prep_time, :cook_time
    end

    recipe_xml = File.read 'benchmarks/recipe.xml'

    Benchmark.bmbm do |x|
      begin
        x.report 'XMLObject (singular)' do
          @singular = XMLObject.new(recipe_xml)

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
          @plural = XMLObject.new(recipe_xml)

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
          @proxy = XMLObject.new(recipe_xml)

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

      begin
        x.report 'XmlSimple' do
          @xml_simple = XmlSimple.xml_in(recipe_xml)

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
    end
  end
end