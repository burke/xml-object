require File.join(File.dirname(__FILE__), 'test_helper')

class XMLStructTest < Test::Unit::TestCase

  include RubyProf::Test if defined? RubyProf::Test

  def setup
    @lorem = XMLStruct.new xml_file(:lorem)
  end

  should 'be an XMLStruct' do
    assert @lorem.is_a?(XMLStruct)
  end

  should 'be blank if devoid of children, attributes and value' do
    assert @lorem.ipsum.blank?
  end

  should 'not be blank when value, children, or attributes are present' do
    assert [ @lorem.dolor, @lorem.sit, @lorem.ut ].all? { |xr| not xr.blank? }
  end

  should 'allow access to attributes named like invalid methods' do
    assert_equal @lorem['_tempor'], 'incididunt'
  end

  should 'allow access to elements named like invalid methods' do
    assert_equal @lorem['_minim'], 'veniam'
  end

  should 'provide unambiguous access to elements named like attributes' do
    assert_equal @lorem.sed[:element => 'do'], 'eiusmod elementus'
  end

  should 'provide unambiguous access to attributes named like elements' do
    assert_equal @lorem.sed[:attribute => 'do'], 'eiusmod attributus'
  end

  should 'return elements first when using dot notation' do
    assert_equal @lorem.sed.do, @lorem.sed[:element => 'do']
  end

  should 'return elements first when using array notation and string key' do
    assert_equal @lorem.sed['do'], @lorem.sed[:element => 'do']
  end

  should 'return elements first when using array notation and symbol key' do
    assert_equal @lorem.sed[:do], @lorem.sed[:element => 'do']
  end

  should 'raise exception when unkown keys are used in hash-in-array mode' do
    assert_raise(RuntimeError) { @lorem[:foo => 'bar'] }
  end

  should 'group multiple parallel namesake elements in arrays' do
    assert @lorem.consectetur.is_a?(Array)
  end

  should 'make auto-grouped arrays accessible by their plural form' do
    assert_same @lorem.consecteturs, @lorem.consectetur
  end

  should 'allow explicit access to elements named like plural arrays' do
    assert_not_same @lorem.consecteturs, @lorem[:element => 'consecteturs']
  end

  should 'convert integer-looking attribute strings to integers' do
    assert @lorem.consecteturs.all? { |c| c[:attr => 'id'].is_a? Numeric }
  end

  should 'convert float-looking attribute strings to floats' do
    assert @lorem.consecteturs.all? { |c| c.capacity.is_a? Float }
  end

  should 'convert bool-looking attribute strings to bools when asked' do
    assert @lorem.consecteturs.all? { |c| c.enabled?.equal? !!(c.enabled?) }
  end

  should 'convert to bool correctly when asked' do
    assert( (@lorem.consecteturs.first.enabled? == true) &&
            (@lorem.consecteturs.last.enabled?  == false) )
  end

  should 'pass forth methods to single array child when empty valued' do
    assert_same @lorem.cupidatats.slice(0),
      @lorem.cupidatats.cupidatat.slice(0)
  end

  should 'not pass methods to single array child if not empty valued' do
    assert_not_same @lorem.voluptate.slice(0),
      @lorem.voluptate.esse.slice(0)
  end

  should 'be valued as its text when text first and CDATA exist' do
    assert_equal @lorem.ullamco, 'Laboris'
  end

  should 'have the value of its first CDATA when multiple exist' do
    assert_equal @lorem.deserunt, 'mollit'
  end

  should 'squish whitespace in string attribute values' do
    assert_equal @lorem.irure.metadata, 'dolor'
  end

  should 'not squish whitespace in string element values' do
    assert_equal @lorem.irure, "  \n\t\t\treprehenderit  "
  end

  should 'not squish whitespace in CDATA values' do
    assert_equal @lorem, "\t foo\n"
  end

  should 'have a working inspect function' do
    assert_nothing_raised { @lorem.inspect.is_a?(String) }
  end
end