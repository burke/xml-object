require 'rubygems'
require 'hpricot'

module XMLObject::Adapters::Hpricot

  # Can take a String of XML data, or anything that responds to
  # either +read+ or +to_s+.
  def self.new(duck)
    case
      when duck.is_a?(::Hpricot::Elem) then Element.new(duck)
      when duck.is_a?(::String)        then new(::Hpricot::XML(duck).root)
      when duck.respond_to?(:read)     then new(duck.read)
      when duck.respond_to?(:to_s)     then new(duck.to_s)
      else raise "Don't know how to deal with '#{duck.class}' object"
    end
  end

  private ##################################################################

  class Element < XMLObject::Adapters::Base::Element # :nodoc:
    def initialize(xml)
      @raw, @name, @attributes = xml, xml.name, xml.attributes

      @element_nodes = xml.children.select { |c| c.elem? }

      @text_nodes = xml.children.select do |c|
        c.text? && !c.is_a?(::Hpricot::CData)
      end.map { |c| c.to_s }

      @cdata_nodes = xml.children.select do |c|
        c.is_a? ::Hpricot::CData
      end.map { |c| c.to_s }

      super
    end
  end
end

def XMLObject.adapter # :nodoc:
  XMLObject::Adapters::Hpricot
end
