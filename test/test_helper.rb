require 'test/unit'
require 'xml-object'

%w[ activesupport libxml ruby-debug leftright ].each do |library|
  begin; require library; rescue LoadError; nil; end
end

puts
puts "  XMLObject #{XMLObject::VERSION} (from #{XMLObject::LOCATION})"
puts

if defined? JRUBY_VERSION
  puts "  Using JRuby #{JRUBY_VERSION} (in #{RUBY_VERSION} mode)"
else
  puts "  Using Ruby #{RUBY_VERSION}"
end

unless defined? ActiveSupport
  puts "    ** Install 'activesupport' to test inflected plurals"
end

unless defined?(LibXML) || defined?(JRUBY_VERSION)
  puts "    ** Install 'libxml-ruby' to test the LibXML adapter"
end

puts
