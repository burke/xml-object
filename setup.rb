PROJECT_DIR = File.expand_path(File.dirname(__FILE__)).chomp('/')

# Include XMLObject
$:.unshift File.join(PROJECT_DIR, 'lib', 'xml-object')
$:.unshift File.join(PROJECT_DIR, 'lib')
require 'xml-object'

