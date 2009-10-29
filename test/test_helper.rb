require 'project_helper'
require 'test/unit'

puts
puts "XMLObject #{XMLObject::VERSION} (from #{XMLObject::LOCATION})"
puts
puts "Testing under Ruby #{RUBY_VERSION}"
puts "(JRuby #{JRUBY_VERSION})\n" if defined?(::JRUBY_VERSION)

XMLObject::Helper.dependency 'activesupport', 'to test proper pluralization'
XMLObject::Helper.dependency 'libxml',        'to test the LibXML adapter'
XMLObject::Helper.dependency 'ruby-debug',    'to debug during testing'
XMLObject::Helper.dependency 'leftright',     'to get colorful tests :)'

puts
puts