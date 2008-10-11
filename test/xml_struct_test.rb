require File.join(File.dirname(__FILE__), 'test_helper')

describe 'XML Struct' do

  include RubyProf::Test if defined? RubyProf::Test

  def setup
    @lorem = XMLStruct.new xml_file(:lorem)
  end

  it 'should be an XMLStruct' do
    @lorem.should.be.an.instance_of XMLStruct
  end

  it 'should be blank if devoid of children, attributes and value' do
    @lorem.ipsum.should.be.blank
  end

  it 'should not be blank when value, children, or attributes are present' do
    @lorem.dolor.should.not.be.blank
    @lorem.sit.should.not.be.blank
    @lorem.ut.should.not.be.blank
  end

  it 'should allow access to attributes named like invalid methods' do
    @lorem['_tempor'].should == 'incididunt'
  end

  xit 'should allow access to elements named like invalid methods' do
    @lorem['_minim'].should == 'veniam'
  end

  xit 'should provide unambiguous access to elements named like attributes' do
    @lorem.sed[:element => 'do'].should == 'eiusmod elementus'
  end

  it 'should provide unambiguous access to attributes named like elements' do
    @lorem.sed[:attribute => 'do'].should == 'eiusmod attributus'
  end

  xit 'should return elements first when using dot notation' do
    @lorem.sed.do.should == @lorem.sed[:element => 'do']
  end

  it 'should return elements first when using array notation and string key' do
    @lorem.sed['do'].should == @lorem.sed[:element => 'do']
  end

  it 'should return elements first when using array notation and symbol key' do
    @lorem.sed[:do].should == @lorem.sed[:element => 'do']
  end

  it 'should raise exception when unkown keys are used in hash-in-array mode' do
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
      c['id'].is_a?(Numeric).should.be true
    end
  end

  it 'should convert float-looking attribute strings to floats' do
    @lorem.consecteturs.each do |c|
      c.capacity.is_a?(Float).should.be true
    end
  end

  it 'should convert bool-looking attribute strings to bools when asked' do
    @lorem.consecteturs.each { |c| c.enabled?.should == !!(c.enabled?) }
  end

  it 'should convert to bool correctly when asked' do
    @lorem.consecteturs.first.enabled?.should.be true
    @lorem.consecteturs.last.enabled?.should.be false
  end

  it 'should pass forth methods to single array child when empty valued' do
    @lorem.cupidatats.slice(0).should.be @lorem.cupidatats.cupidatat.slice(0)
  end

  it 'should not pass methods to single array child if not empty valued' do
    @lorem.voluptate.slice(0).should.not.be @lorem.voluptate.esse.slice(0)
  end

  xit 'should be valued as its text when text first and CDATA exist' do
    @lorem.ullamco.should == 'Laboris'
  end

  xit 'should have the value of its first CDATA when multiple exist' do
    @lorem.deserunt.should == 'mollit'
  end

  it 'should squish whitespace in string attribute values' do
    @lorem.irure.metadata.should == 'dolor'
  end

  xit 'should not squish whitespace in string element values' do
    @lorem.irure.should == "  \n\t\t\treprehenderit  "
  end

  xit 'should not squish whitespace in CDATA values' do
    @lorem.should == "\t foo\n"
  end

  it 'should have a working inspect function' do
    should.not.raise { @lorem.inspect.is_a?(String) }
  end
end