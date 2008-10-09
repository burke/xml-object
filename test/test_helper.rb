require 'test/unit'
require 'rubygems'

begin
  require 'redgreen'
rescue LoadError
  puts "Install the 'redgreen' gem to get color output"
end

require File.join(File.dirname(__FILE__), '..', 'lib', 'xml_struct')

def xml_file(name_symbol)
  File.open File.join(File.dirname(__FILE__), 'samples',
    "#{name_symbol.to_s}.xml")
end

require 'digest/md5'
{ :lorem => '6dc88e269000db3be599fca3367e2aa5' }.each do |file_key, md5|

  unless Digest::MD5.hexdigest(xml_file(file_key).read) == md5
    raise "Sample test file #{file_key.to_s}.xml doesn't match expected MD5"
  end
end

class Test::Unit::TestCase
  def self.should(do_stuff_that_is_true, &block)

    object = to_s.split('Test').first
    method = "test that #{object} should #{do_stuff_that_is_true}"

    define_method(method.intern) { assert block.bind(self).call }
  end

  def debug
    require 'ruby-debug'; debugger
  end
end