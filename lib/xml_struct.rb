require 'rubygems'
require 'activesupport'

module XMLStruct; end

require File.join(File.dirname(__FILE__), 'xml_struct', 'blankish_slate')
require File.join(File.dirname(__FILE__), 'xml_struct', 'collection_proxy')
require File.join(File.dirname(__FILE__), 'xml_struct', 'string')
require File.join(File.dirname(__FILE__), 'xml_struct', 'common_behaviours')
require File.join(File.dirname(__FILE__), 'xml_struct', 'backends', 'rexml')

module XMLStruct
  # Returns a String or Array object representing the given XML, decorated
  # with methods to access attributes and/or child elements.
  def self.new(duck)
    @backend ||= ::XMLStruct::Backends::REXML

    case duck
      when @backend::Element : new_decorated_obj(duck)
      when Array             : duck.map { |d| new_decorated_obj(d) }
      else new @backend.new(duck)
    end
  end

  # Takes any REXML::Element object, and converts it recursively into
  # the corresponding tree of decorated objects.
  def self.new_decorated_obj(xml)
    obj = if xml.value.blank? &&
             xml.children.collect { |e| e.name }.uniq.size == 1

      CollectionProxy.new new(xml.children)
    else
      xml.value.extend String
    end

    obj.instance_variable_set :@__raw_xml, xml

    xml.children.each   { |child| add_child(obj, child.name, new(child)) }
    xml.attributes.each { |name, value|  add_attribute(obj, name, value) }

    obj.extend CommonBehaviours
  end

  private ##################################################################

  # Decorates the given object 'obj' with a method 'name' that returns the
  # given 'element'. If 'name' is already taken, takes care of the array
  # folding behaviour.
  def self.add_child(obj, name, element)
    key      = name.to_sym
    children = obj.instance_variable_get :@__children

    children[key] = if children[key]

      unless obj.respond_to?((plural_key = key.to_s.pluralize).to_sym)
          begin
            obj.instance_eval %{
              def #{plural_key}; @__children[%s|#{key.to_s}|]; end }
          rescue SyntaxError
            nil
          end
      end

      children[key] = [ children[key] ] unless children[key].is_a? Array
      children[key] << element
    else
      unless obj.respond_to? key
        begin
          obj.instance_eval %{
            def #{key.to_s}; @__children[%s|#{key.to_s}|]; end }
        rescue SyntaxError
          nil
        end
      end

      element
    end

    obj.instance_variable_set :@__children, children
    element
  end

  # Decorates the given object 'obj' with a method 'name' that returns the
  # given 'attr_value'.
  def self.add_attribute(obj, name, attr_value) # :nodoc:

    attributes = obj.instance_variable_get :@__attributes
    attributes[(key = name.to_sym)] = attr_value.squish.extend String

    unless obj.respond_to? key
      begin
        obj.instance_eval %{
          def #{key.to_s}; @__attributes[%s|#{key.to_s}|]; end }
      rescue SyntaxError
        nil
      end
    end

    obj.instance_variable_set :@__attributes, attributes
    attr_value
  end
end