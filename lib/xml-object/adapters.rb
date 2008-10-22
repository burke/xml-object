module XMLObject # :nodoc:
  def self.adapter # :nodoc:
    @adapter
  end

  def self.adapter=(adapter_module) # :nodoc:
    @adapter = adapter_module
  end

  module Adapters # :nodoc:
    module Base # :nodoc:
      class Element # :nodoc:
        attr_accessor :raw, :name, :value, :attributes, :children # :nodoc:

        def initialize(*args)

          @children = @element_nodes.map { |node| self.class.new(node) }

          @value = case
            when (not text_value.blank?)  then text_value
            when (not cdata_value.blank?) then cdata_value
            else ''
          end
        end

        private ###########################################################

        def text_value
          @text_nodes.reject { |n| n !~ /\S/ }.join
        end

        def cdata_value
          @cdata_nodes.join
        end
      end
    end
  end
end
