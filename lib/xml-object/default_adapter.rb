module XMLObject # :nodoc:
  module Adapters # :nodoc:
    ADAPTERS_PATH = File.join(File.dirname(__FILE__), 'adapters')

    Default = begin
      require 'hpricot'
      require File.join(ADAPTERS_PATH, 'hpricot')
      $FAKE_HPRICOT_LOAD_ERROR ? raise(LoadError) : Hpricot
    rescue LoadError
      require File.join(ADAPTERS_PATH, 'rexml')
      REXML
    end
  end
end

