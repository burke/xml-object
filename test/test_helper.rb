require 'setup'

# Include the "lib" folder of test vendor:
Dir[File.join(PROJECT_DIR, 'vendor', '*')].each do |vendor|

  lib = File.join(vendor, 'lib')
  $:.unshift lib if File.directory?(lib)
end

require 'bacon'
require 'digest/md5'
require 'stringio'

puts "Ruby #{RUBY_VERSION}#{" (JRuby #{JRUBY_VERSION})" rescue ''}"

begin_require_rescue 'rubygems'
begin_require_rescue 'activesupport', 'to test proper pluralization'
begin_require_rescue 'hpricot',       'to test the Hpricot adapter'
begin_require_rescue 'libxml',        'to test the LibXML adapter'
begin_require_rescue 'ruby-debug'

puts
puts
