require 'rubygems'
require 'activesupport'
require 'rexml/document'

class XMLStruct

  include Comparable

  # Returns an XMLStruct object
  def self.new(duck)
    duck.is_a?(REXML::Element) ? super : new(REXML::Document.new(duck).root)
  end

  # Takes any REXML::Element object, and converts it recursively into
  # the corresponding tree of XMLStruct objects
  def initialize(raw)
    @attributes, @children, @raw = {}, {}, raw
    @value = __get_value_from_raw_element @raw

    @raw.each_element    { |el|   __set_child el.name, self.class.new(el) }
    @raw.attributes.each { |n, v| __set_attribute n, v                    }
  end

  # An XMLStruct is blank when it has a blank value, no child elements,
  # and no attributes. For example:
  #
  #    <blank_element></blank_element>
  def blank?
    @value.blank? && @children.blank? && @attributes.blank?
  end

  # XMLStruct objects are compared according to their values
  def <=>(other)
    @value <=> other
  end

  # Array-notation access to elements and attributes. It comes handy when
  # the element or attribute you need to reach is not reachable via dot
  # notation (because it's not a valid method name, or because the method
  # exists, such as 'id' or 'class').
  #
  # It also supports hash keys, which are useful to reach attributes named
  # the same as elements in the same level (which are otherwise prioritized)
  #
  # All of this is a lot easier to exampling by example:
  #
  #   <article id="main_article" author="j-random">
  #     <author>J. Random Hacker</author>
  #   </article>
  #
  #   article.id                 => 9314390         # Object#id gets called
  #   article[:id]               => "main_article"  # id attribute
  #   article[:author]           => <XMLStruct ...> # <author> element
  #   article[:attr => 'author'] => "j-random"      # author attribute
  #
  # Valid keys for the hash notation in the example above are :attr,
  # :attribute, :child, and :element.
  def [](name)
    unless name.is_a? Hash
      return @children[name.to_sym]   if @children[name.to_sym]
      return @attributes[name.to_sym] if @attributes[name.to_sym]
    end

    raise 'one and only one key allowed' if name.size != 1

    case (param = name.keys.first.to_sym)
      when :element   : @children[name.values.first.to_sym]
      when :child     : @children[name.values.first.to_sym]
      when :attr      : @attributes[name.values.first.to_sym]
      when :attribute : @attributes[name.values.first.to_sym]
      else raise %{ Invalid key :#{param.to_s}.
        Use one of :element, :child, :attr, or :attribute }.squish!
    end
  end

  def method_missing(method, *args, &block) # :nodoc:

    if method.to_s.match(/\?$/) && args.empty? && block.nil?
      boolish = send(method.to_s.chomp('?').to_sym).to_s

      %w[ true yes t y ].include? boolish.downcase

    elsif @value.blank? && (@children.size == 1) &&
      (single_child = @children.values.first).respond_to?(method)

      single_child.send method, *args, &block
    else
      @value.send method, *args, &block
    end
  end

  def inspect # :nodoc:
    %{ #<#{self.class.to_s} value=#{@value.inspect} (#{@value.class.to_s})
         attributes=[#{@attributes.keys.map(&:to_s).join(', ') }]
         children=[#{@children.keys.map(&:to_s).join(', ')     }]> }.squish
  end

  private

  def __set_child(name, element) # :nodoc:
    key = name.to_sym

    @children[key] = if @children[key]

      unless respond_to?((plural_key = key.to_s.pluralize).to_sym)
        instance_eval %{ def #{plural_key}; @children[:#{key.to_s}]; end }
      end

      @children[key] = [ @children[key] ] unless @children[key].is_a? Array
      @children[key] << element
    else
      unless respond_to? key
        instance_eval %{ def #{key.to_s}; @children[:#{key.to_s}]; end }
      end

      element
    end
  end

  def __set_attribute(name, attribute) # :nodoc:
    obj = __get_object_from_string(attribute)
    @attributes[(key = name.to_sym)] = obj.is_a?(String) ? obj.squish : obj

    unless respond_to? key
      instance_eval %{ def #{key.to_s}; @attributes[:#{key.to_s}]; end }
    end
  end

  def __get_value_from_raw_element(raw) # :nodoc:
    str = case
      when raw.has_text? && !raw.text.blank? : raw.text
      else (raw.cdatas.first.to_s rescue '')
    end

    __get_object_from_string str
  end

  def __get_object_from_string(str) # :nodoc:
    case
      when str.blank?              : nil
      when str.match(/[a-zA-Z]/)   : str
      when str.match(/^[+-]?\d+$/) : str.to_i
      when str.match(/^[+-]?(?:\d+(?:\.\d*)?|\.\d+)$/) : str.to_f
      else str
    end
  end
end