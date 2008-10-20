require File.join(File.dirname(__FILE__), 'test_helper')

describe_shared 'All built-in XMLObject Adapters' do
  it 'should know how start with something that knows #to_s' do
    should.not.raise do
      @foo = XMLObject.new '<foo bar="true"><baz>Boo</baz></foo>'
    end

    @foo.bar?.should.be true
    @foo.baz.should == 'Boo'
  end

  it 'should know how start with something that knows #read' do
    should.not.raise do

      knows_read = StringIO.new('<foo bar="true"><baz>Boo</baz></foo>')
      class << knows_read
        undef_method :to_s
      end

      @foo = XMLObject.new(knows_read)
    end

    @foo.bar?.should.be true
    @foo.baz.should == 'Boo'
  end

  it 'should raise hell at something that does not know #read or #to_s' do
    dumb = lambda {}
    class << dumb
      undef_method(:to_s) rescue nil
      undef_method(:read) rescue nil
    end

    should.raise { XMLObject.new(dumb) }
  end
end

describe_shared 'All XMLObject Adapters' do
  describe 'An XML file with weird characters' do

    it 'should not raise exceptions' do
      should.not.raise(Exception) do
        @xml = XMLObject.new xml_file(:characters)
      end
    end

    it 'should allow access to attributes with dashes in the name' do
      XMLObject.new(
        xml_file(:characters))['attr-with-dashes'].should == 'lame'
    end
  end

  describe 'README Recipe' do

    before(:each) { @recipe = XMLObject.new(xml_file(:recipe)) }

    it 'should have name and title as "bread" and "Basic bread"' do
      @recipe.name.should  == "bread"
      @recipe.title.should == "Basic bread"
    end

    it 'should treat "recipe.ingredients" as an Array' do
      @recipe.ingredients.is_a?(Array).should.be true
      @recipe.ingredients.first.amount.to_i.should == 8
    end

    it 'should have 7 easy instructions' do
      @recipe.instructions.easy?.should.be true
      @recipe.instructions.steps.size.should == 7
      @recipe.instructions.first.upcase.should ==
        "MIX ALL INGREDIENTS TOGETHER."
    end
  end

  describe 'XMLObject' do

    before(:each) { @lorem = XMLObject.new(xml_file(:lorem)) }

    it 'should be an instance of XMLObject::String' do
      @lorem.should.be.an.instance_of ::String
    end

    it 'be blank if devoid of children, attributes and value' do
      @lorem.ipsum.should.be.blank?
    end

    it 'not be blank when value, children, or attributes are present' do
      [ @lorem.dolor, @lorem.sit, @lorem.ut ].each do |xr|
        xr.should.not.be.blank?
      end
    end

    it 'should allow access to attributes named like invalid methods' do
      @lorem['_tempor'].should == 'incididunt'
    end

    it 'should allow access to elements named like invalid methods' do
      @lorem['_minim'].should == 'veniam'
    end

    it 'should provide unambiguous access to elements over attributes' do
      @lorem.sed[:element => 'do'].should == 'eiusmod elementus'
    end

    it 'should provide unambiguous access to attributes over elements' do
      @lorem.sed[:attribute => 'do'].should == 'eiusmod attributus'
    end

    it 'should return elements first when using dot notation' do
      @lorem.sed.do.should == @lorem.sed[:element => 'do']
    end

    it 'should return elements first when using [] with string key' do
      @lorem.sed['do'].should == @lorem.sed[:element => 'do']
    end

    it 'should return elements first when using [] with symbol key' do
      @lorem.sed[:do].should == @lorem.sed[:element => 'do']
    end

    it 'should raise exception when unkown keys are used in [{}] mode' do
      should.raise(RuntimeError) { @lorem[:foo => 'bar'] }
    end

    it 'should group multiple parallel namesake elements in arrays' do
      @lorem.consectetur.is_a?(Array).should.be true
    end

    it 'should make auto-grouped arrays accessible by their plural form' do
      @lorem.consecteturs.should.be @lorem.consectetur
    end

    it 'should allow explicit access to elements named like plural arrays' do
      @lorem.consecteturs.should.not.be @lorem[:element => 'consecteturs']
    end

    it 'should convert integer-looking attribute strings to integers' do
      @lorem.consecteturs.each do |c|
        c['id'].rb.is_a?(Numeric).should.be true
      end
    end

    it 'should convert float-looking attribute strings to floats' do
      @lorem.consecteturs.each do |c|
        c.capacity.rb.is_a?(Float).should.be true
      end
    end

    it 'should not convert strings with more than numbers to Fixnum' do
      @lorem.sed.do.price.rb.should == @lorem.sed.do.price
      @lorem.sed.do.price.rb.should.not == 8
    end

    it 'should not return bools when asked for non-boolish strings' do
      @lorem.dolor.foo?.should.not.be true
      @lorem.dolor.foo?.should.not.be false
    end

    it 'should convert bool-looking attribute strings to bools when asked' do
      @lorem.consecteturs.each { |c| c.enabled?.should == !!(c.enabled?) }
    end

    it 'should convert to bool correctly when asked' do
      @lorem.consecteturs.first.enabled?.should.be true
      @lorem.consecteturs.last.enabled?.should.be false
    end

    it 'should pass forth methods to single array child when empty valued' do
      @lorem.cupidatats[0].should == @lorem.cupidatats.cupidatat[0]
    end

    it 'should not pass methods to single array child if not empty valued' do
      should.raise(RuntimeError) { @lorem.voluptate[0] }
    end

    it 'should be valued as its text when text first and CDATA exist' do
      @lorem.ullamco.should == 'Laboris'
    end

    it 'should have the value of its first CDATA when multiple exist' do
      @lorem.deserunt.should == 'mollit'
    end

    it 'should squish whitespace in string attribute values' do
      @lorem.irure.metadata.should == 'dolor'
    end

    it 'should not squish whitespace in string element values' do
      @lorem.irure.should == "  \n\t\t\treprehenderit  "
    end

    it 'should not squish whitespace in CDATA values' do
      @lorem.should == "\t foo\n"
    end

    it 'should have a working inspect function' do
      should.not.raise { @lorem.inspect.is_a?(String) }
    end
  end
end

describe 'REXML Adapter' do
  it_should_behave_like 'All XMLObject Adapters'
  it_should_behave_like 'All built-in XMLObject Adapters'

  it 'should return REXML::Element objects when #raw_xml is called' do
    @rexml_recipe = XMLObject.new(xml_file(:recipe))
    @rexml_recipe.raw_xml.is_a?(::REXML::Element).should.be true
  end
end

describe 'Hpricot Adapter' do
  before(:all) { require('adapters/hpricot') }

  it_should_behave_like 'All XMLObject Adapters'
  it_should_behave_like 'All built-in XMLObject Adapters'

  it 'should return Hpricot::Elem objects when #raw_xml is called' do
    @hpricot_recipe = XMLObject.new(xml_file(:recipe))
    @hpricot_recipe.raw_xml.is_a?(::Hpricot::Elem).should.be true
  end
end
