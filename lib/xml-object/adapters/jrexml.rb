require 'jrexml'
require File.join(File.dirname(__FILE__), 'rexml')

module XMLObject::Adapters
  JREXML = REXML
end

def XMLObject.adapter # :nodoc:
  XMLObject::Adapters::JREXML
end
