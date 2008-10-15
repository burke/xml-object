module XMLStruct
  module Adapters
    ADAPTERS_PATH = File.join(File.dirname(__FILE__), 'adapters')

    Default = begin
      require 'hpricot'
      require File.join(ADAPTERS_PATH, 'hpricot')
      Hpricot
    rescue LoadError
      require File.join(ADAPTERS_PATH, 'rexml')
      REXML
    end
  end
end

