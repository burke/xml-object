PROJECT_DIR = File.expand_path(File.dirname(__FILE__)).chomp('/')

# Include XMLObject from here, not from installed gems:
$:.unshift File.join(PROJECT_DIR, 'lib')
require 'xml-object'

def open_sample_xml(name_symbol)
  File.open(File.join(PROJECT_DIR,
  'test', 'samples', "#{name_symbol.to_s}.xml"))
end

def begin_require_rescue(gem, reason = nil)
  begin; require gem; rescue Exception, StandardError
    puts "Install '#{gem}' #{reason.strip.gsub(/\s+/, ' ')}" if reason
  end
end
