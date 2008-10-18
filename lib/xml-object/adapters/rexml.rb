module XMLObject::Adapters::REXML
  require 'rexml/document'

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

  class Element # :nodoc:
    attr_reader :raw, :name, :value, :attributes, :children

    def initialize(xml)
      @raw, @name, @attributes, @children = xml, xml.name, {}, []

      @attributes = xml.attributes
      xml.each_element { |e| @children << self.class.new(e) }

      @value = case
        when (not xml.text.blank?)  then xml.text.to_s
        when (xml.cdatas.size >= 1) then xml.cdatas.first.to_s
        else ''
      end
    end
  end
end
