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

puts "Ruby #{RUBY_VERSION}#{" (JRuby #{JRUBY_VERSION})" rescue ''}"

begin_require_rescue 'rubygems'
begin_require_rescue 'redgreen', 'to get color output on tests'
begin_require_rescue 'activesupport'
begin_require_rescue 'hpricot'
begin_require_rescue 'ruby-debug'
begin_require_rescue 'libxml'
