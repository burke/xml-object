require 'rake'
PROJECT_DIR = File.expand_path(File.dirname(__FILE__)).chomp('/')
require File.join(PROJECT_DIR, 'lib', 'xml-object')

Dir[File.join(PROJECT_DIR, 'tasks', '*.rake')].sort.each do |rf|
  import rf
end

