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

def xml_file(name_symbol)
  File.open File.join(PROJECT_DIR,
    'test', 'samples', "#{name_symbol.to_s}.xml")
end

def begin_require_rescue(gem, reason = nil)
  begin; require gem; rescue Exception, StandardError
    puts "Install the '#{gem}' gem #{reason.squish!}" unless reason.nil?
  end
end

begin_require_rescue 'rubygems',      'to load additional gems'
begin_require_rescue 'redgreen',      'to get color output'
begin_require_rescue 'ruby-prof',     'to get profiling information'
begin_require_rescue 'ruby-debug',    'to use the debugger during tests'
begin_require_rescue 'activesupport', 'to test auto array pluralization'
begin_require_rescue 'hpricot',       'to test the Hpricot adapter'

if RUBY_PLATFORM =~ /java/
  begin_require_rescue 'jrexml', 'to test the JREXML adapter'
else
  begin_require_rescue 'libxml', 'to test the LibXML adapter'
end

{ :lorem      => '61cd24e2959669c3719fbebf6c948cd3',
  :characters => 'cdcbd9b89b261487fa98c11d856f50fe',
  :plurals    => '1c22f96d00bc2277cece4d93154ad974',
  :recipe     => '6087ab42049273d123d473093b04ab12' }.each do |sample, md5|

  unless Digest::MD5.hexdigest(xml_file(sample).read) == md5
    puts "Sample file #{sample.to_s}.xml doesn't match expected MD5"
    exit(1)
  end
end