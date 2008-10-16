module XMLObject::Adapters::Hpricot

  # Can take a String of XML data, or anything that responds to
  # either +read+ or +to_s+.
  def self.new(duck)
    case
      when duck.is_a?(::Hpricot::Elem) : Element.new(duck)
      when duck.is_a?(::String)        : new(::Hpricot::XML(duck).root)
      when duck.respond_to?(:read)     : new(duck.read)
      when duck.respond_to?(:to_s)     : new(duck.to_s)
      else raise "Don't know how to deal with '#{duck.class}' object"
    end
  end

  private ##################################################################

  class Element # :nodoc:
    attr_reader :raw, :name, :value, :attributes, :children

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

    def initialize(xml)
      @raw, @name, @attributes, @children = xml, xml.name, {}, []

      @attributes = xml.attributes
      xml.children.select { |e| e.elem? }.each do |e|
        @children << self.class.new(e)
      end

      @value = case
        when (not text_value(@raw).blank?)  : text_value(@raw)
        when (not cdata_value(@raw).blank?) : cdata_value(@raw)
        else ''
      end
    end
  end
end