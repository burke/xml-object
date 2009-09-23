$:.unshift 'lib' # include XMLObject from here, not from installed gems.
require 'xml-object'
require 'pathname'

module XMLObject
  module Helper
    def self.dir
      @_dir ||= begin
        Pathname.new File.expand_path(File.dirname(__FILE__)).chomp('/')
      end
    end

    def self.sample(name_symbol)
      File.open(self.dir.join('test', 'samples', "#{name_symbol.to_s}.xml"))
    end

    def self.dependency(dep, reason = nil)
      begin; require dep; rescue Exception, StandardError
        puts "Install '#{dep}' #{reason.strip.gsub(/\s+/, ' ')}" if reason
      end
    end
  end
end