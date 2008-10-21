require 'jrexml'
require File.join(File.dirname(__FILE__), 'rexml')

module XMLObject::Adapters
  JREXML = REXML
end

::XMLObject.adapter = ::XMLObject::Adapters::JREXML
