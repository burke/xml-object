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
      self.raw, self.name, self.attributes = xml, xml.name, xml.attributes
      self.children = xml.elements.map { |raw_xml| self.class.new(raw_xml) }

      self.value = case
        when (not xml.text.blank?) then xml.text.to_s
        when (xml.cdatas.any?)     then xml.cdatas.first.to_s
        else ''
      end
    end
  end
end

def XMLObject.adapter # :nodoc:
  XMLObject::Adapters::REXML
end
