require 'project_helper'

# Include the "lib" folder of test vendor:
Dir[XMLObject::Helper.dir.join('vendor', '*')].each do |vendor|
  lib = File.join(vendor, 'lib')
  $:.unshift lib if File.directory?(lib)
end

require 'bacon'
require 'digest/md5'
require 'stringio'

puts "Ruby #{RUBY_VERSION}#{" (JRuby #{JRUBY_VERSION})" rescue ''}"

XMLObject::Helper.dependency 'activesupport', 'to test proper pluralization'
XMLObject::Helper.dependency 'libxml',        'to test the LibXML adapter'
XMLObject::Helper.dependency 'ruby-debug'

puts
puts