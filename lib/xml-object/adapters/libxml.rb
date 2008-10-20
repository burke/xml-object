require 'libxml'

module XMLObject::Adapters::LibXML

  # Can take a String of XML data, or anything that responds to
  # either +read+ or +to_s+.
  def self.new(duck)
    case
      when duck.is_a?(::LibXML::XML::Node) then Element.new(duck)
      when duck.is_a?(::String)
        then new(::LibXML::XML::Parser.string(duck).parse.root)
      when duck.respond_to?(:read) then new(duck.read)
      when duck.respond_to?(:to_s) then new(duck.to_s)
      else raise "Don't know how to deal with '#{duck.class}' object"
    end
  end

  private ##################################################################

  class Element < XMLObject::Adapters::Base::Element # :nodoc:
    def initialize(xml)
      @raw, @name, @attributes = xml, xml.name, xml.attributes.to_h

      @element_nodes = xml.children.select { |c| c.element? }

      @text_nodes  = xml.children.select { |c| c.text? }.map { |c| c.to_s }
      @cdata_nodes = xml.children.select { |c| c.cdata? }.map do |c|
        c.to_s.chomp(']]>').sub('<![CDATA[', '')
      end

      super
    end
  end
end

def XMLObject.adapter # :nodoc:
  XMLObject::Adapters::LibXML
end
