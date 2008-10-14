module XMLStruct
  module Backends
  end
end

class XMLStruct::Backends::REXML
  require 'rexml/document'

  def self.new(duck)
    case duck
      when ::REXML::Element : Element.new(duck)
      when ::String         : new(File.open(duck))
      when ::File           : new(::REXML::Document.new(duck).root)
      else raise "Don't know how to deal with '#{duck.class}' object"
    end
  end

  class Element
    attr_reader :raw, :name, :value, :attributes, :children

    def initialize(xml)
      @raw, @name, @attributes, @children = xml, xml.name, {}, []

      @attributes = xml.attributes
      xml.each_element { |e| @children << self.class.new(e) }

      @value = case
        when (not xml.text.blank?)  : xml.text.to_s
        when (xml.cdatas.size >= 1) : xml.cdatas.first.to_s
        else ''
      end
    end
  end
end
