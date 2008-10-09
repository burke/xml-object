require File.join(File.dirname(__FILE__), 'test_helper')

class XMLStructTest < Test::Unit::TestCase

  include RubyProf::Test if defined? RubyProf::Test

  def setup
    @lorem = XMLStruct.new xml_file(:lorem)
  end

  should 'be an XMLStruct' do
    @lorem.is_a? XMLStruct
  end

  should 'be blank if devoid of children, attributes and value' do
    @lorem.ipsum.blank?
  end

  should 'not be blank when value, children, or attributes are present' do
    [ @lorem.dolor, @lorem.sit, @lorem.ut ].all? { |xr| not xr.blank? }
  end

  should 'allow access to attributes named like invalid methods' do
    @lorem['_tempor'] == 'incididunt'
  end

  should 'allow access to elements named like invalid methods' do
    @lorem['_minim'] == 'veniam'
  end

  should 'provide unambiguous access to elements named like attributes' do
    @lorem.sed[:element => 'do'] == 'eiusmod elementus'
  end

  should 'provide unambiguous access to attributes named like elements' do
    @lorem.sed[:attribute => 'do'] == 'eiusmod attributus'
  end

  should 'return elements first when using dot notation' do
    @lorem.sed.do == @lorem.sed[:element => 'do']
  end

  should 'return elements first when using array notation and string key' do
    @lorem.sed['do'] == @lorem.sed[:element => 'do']
  end

  should 'return elements first when using array notation and symbol key' do
    @lorem.sed[:do] == @lorem.sed[:element => 'do']
  end

  should 'raise exception when unkown keys are used in hash-in-array mode' do
    (@lorem[:foo => 'bar']; false) rescue true
  end

  should 'group multiple parallel namesake elements in arrays' do
    @lorem.consectetur.is_a? Array
  end

  should 'make auto-grouped arrays accessible by their plural form' do
    @lorem.consecteturs.equal? @lorem.consectetur
  end

  should 'allow explicit access to elements named like plural arrays' do
    not @lorem.consecteturs.equal? @lorem[:element => 'consecteturs']
  end

  should 'convert integer-looking attribute strings to integers' do
    @lorem.consecteturs.all? { |c| c[:attr => 'id'].is_a? Numeric }
  end

  should 'convert float-looking attribute strings to floats' do
    @lorem.consecteturs.all? { |c| c.capacity.is_a? Float }
  end

  should 'convert bool-looking attribute strings to bools when asked' do
    @lorem.consecteturs.all? { |c| c.enabled?.equal? !!(c.enabled?) }
  end

  should 'convert to bool correctly when asked' do
    @lorem.consecteturs.first.enabled? == true &&
    @lorem.consecteturs.last.enabled?  == false
  end

  should 'pass forth methods to single array child when empty valued' do
    @lorem.cupidatats.slice(0).equal? @lorem.cupidatats.cupidatat.slice(0)
  end

  should 'not pass methods to single array child if not empty valued' do
    not @lorem.voluptate.slice(0).equal? @lorem.voluptate.esse.slice(0)
  end

  should 'be valued as its text when text first and CDATA exist' do
    @lorem.ullamco == 'Laboris'
  end

  should 'have the value of its first CDATA when multiple exist' do
    @lorem.deserunt == 'mollit'
  end

  should 'squish whitespace in string attribute values' do
    @lorem.irure.metadata == 'dolor'
  end

  should 'not squish whitespace in string element values' do
    @lorem.irure == "  \n\t\t\treprehenderit  "
  end

  should 'not squish whitespace in CDATA values' do
    @lorem == "\t foo\n"
  end

  should 'have a working inspect function' do
    (@lorem.inspect.to_s.is_a? String; true) rescue false
  end
end