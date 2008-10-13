require 'test/unit'
require 'rubygems'
require File.join(File.dirname(__FILE__),
  'vendor', 'test-spec', 'lib', 'test', 'spec')

begin
  require 'redgreen'
rescue LoadError
  puts "Install the 'redgreen' gem to get color output"
end

begin
  require 'ruby-prof'
rescue LoadError
  puts "Install the 'ruby-prof' gem (>= 0.6.1) to get profiling information"
end

require File.join(File.dirname(__FILE__), '..', 'lib', 'xml_struct')

def xml_file(name_symbol)
  File.open File.join(File.dirname(__FILE__), 'samples',
    "#{name_symbol.to_s}.xml")
end

require 'digest/md5'
{ :lorem  => '6dc88e269000db3be599fca3367e2aa5',
  :recipe => '6087ab42049273d123d473093b04ab12' }.each do |file_key, md5|

  unless Digest::MD5.hexdigest(xml_file(file_key).read) == md5
    raise "Sample test file #{file_key.to_s}.xml doesn't match expected MD5"
  end
end

class Test::Unit::TestCase
  def debug
    require 'ruby-debug'; debugger
  end
end