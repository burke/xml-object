module XMLStruct
  module Backends
  end
end

class XMLStruct::Backends::Hpricot
  require 'hpricot'

  def self.new(duck)
    case duck
      when ::Hpricot::Elem : Element.new(duck)
      when ::String        : new(File.open(duck))
      when ::File          : new(::Hpricot::XML(duck).root)
      else raise "Don't know how to deal with '#{duck.class}' object"
    end
  end

  class Element
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
