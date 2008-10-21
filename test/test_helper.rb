require 'setup'

# Include the "lib" folder of each test vendor:
Dir[File.join(PROJECT_DIR, 'test', 'vendor', '*')].each do |vendor|

  lib = File.join(vendor, 'lib')
  $:.unshift lib if File.directory?(lib)
end

require 'test/unit'
require 'test/spec'
require 'digest/md5'
require 'stringio'

begin_require_rescue 'rubygems',      'to load additional gems'
begin_require_rescue 'redgreen',      'to get color output on tests'
begin_require_rescue 'activesupport', 'to test proper array pluralization'
begin_require_rescue 'hpricot',       'to test the Hpricot adapter'
begin_require_rescue 'ruby-debug'

unless defined?(JRUBY_VERSION)
  begin_require_rescue 'libxml', 'to test the LibXML adapter'
end
