PROJECT_DIR = File.expand_path(File.dirname(__FILE__)).chomp('/')

# Include XMLObject from here, not from installed gems:
$:.unshift File.join(PROJECT_DIR, 'lib')
require 'xml-object'

def begin_require_rescue(gem, reason = nil)
  begin; require gem; rescue Exception, StandardError
    puts "Install the '#{gem}' gem #{reason.squish!}" unless reason.nil?
  end
end

def open_sample_xml(name_symbol)
  File.open(File.join(PROJECT_DIR,
    'test', 'samples', "#{name_symbol.to_s}.xml"))
end

puts (if defined?(JRUBY_VERSION)
  "Ruby #{RUBY_VERSION} (JRuby #{JRUBY_VERSION})"
else
  "Ruby #{RUBY_VERSION} (MRI)"
end)
