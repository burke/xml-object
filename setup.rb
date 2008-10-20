PROJECT_DIR = File.expand_path(File.dirname(__FILE__)).chomp('/')

# Include XMLObject from here, not from installed gems:
$:.unshift File.join(PROJECT_DIR, 'lib')
require 'xml-object'

