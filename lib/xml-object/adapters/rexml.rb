require 'rexml/document'

module XMLObject::Adapters::REXML

  # Can take a String of XML data, or anything that responds to
  # either +read+ or +to_s+.
  def self.new(duck)
    case
      when duck.is_a?(::REXML::Element) then Element.new(duck)
      when duck.is_a?(::String)    then new(::REXML::Document.new(duck).root)
      when duck.respond_to?(:read) then new(duck.read)
      when duck.respond_to?(:to_s) then new(duck.to_s)
      else raise "Don't know how to deal with '#{duck.class}' object"
    end
  end

  private ##################################################################

  class Element < XMLObject::Adapters::Base::Element # :nodoc:
    def initialize(xml)
      @raw, @name, @attributes = xml, xml.name, xml.attributes

      @element_nodes = xml.elements

      @text_nodes = xml.children.select do |child|
        child.class == ::REXML::Text
      end.collect { |child| child.to_s }

      @cdata_nodes = xml.children.select do |child|
        child.class == ::REXML::CData
      end.collect { |child| child.to_s }

      super
    end
  end
end

def XMLObject.adapter # :nodoc:
  XMLObject::Adapters::REXML
end
