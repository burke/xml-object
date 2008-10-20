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
      self.raw, self.name, self.attributes = xml, xml.name, xml.attributes
      self.children = xml.children.select { |e| e.elem? }.map do |raw_xml|
        self.class.new(raw_xml)
      end

      self.value = case
        when (not text_value(xml).blank?)  then text_value(xml)
        when (not cdata_value(xml).blank?) then cdata_value(xml)
        else ''
      end
    end

    private ################################################################

    def text_value(raw)
      raw.children.select do |e|
        (e.class == ::Hpricot::Text) && !e.to_s.blank?
      end.join.to_s
    end

    def cdata_value(raw)
      raw.children.select do |e|
        (e.class == ::Hpricot::CData) && !e.to_s.blank?
      end.first.to_s
    end
  end
end

# Set the adapter:
def XMLObject.adapter; XMLObject::Adapters::Hpricot; end
