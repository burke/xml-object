require 'rubygems'
require 'activesupport'

module XMLObject # :nodoc:
  VERSION = '0.9.5'
end

require 'adapters'
require 'adapters/rexml'
require 'array_notation'
require 'blankish_slate'
require 'collection_proxy'
require 'method_missing_dispatchers'
require 'string'

module XMLObject
  # Returns a String or Array object representing the given XML, decorated
  # with methods to access attributes and/or child elements.
  def self.new(duck)
    case duck
      when adapter::Element then new_decorated_obj(duck)
      when Array            then duck.map { |d| new_decorated_obj(d) }
      else new adapter.new(duck)
    end
  end

  private ##################################################################

  # Takes any Element object, and converts it recursively into
  # the corresponding tree of decorated objects.
  def self.new_decorated_obj(xml) # :nodoc:
    obj = if xml.value.blank? &&
             xml.children.collect { |e| e.name }.uniq.size == 1

      CollectionProxy.new new(xml.children)
    else
      xml.value.extend String # Teach our string to behave like XML
    end

    obj.instance_variable_set :@__raw_xml, xml

    xml.children.each   { |child| add_child(obj, child.name, new(child)) }
    xml.attributes.each { |name, value|  add_attribute(obj, name, value) }

    # Let's teach our object some new tricks:
    obj.extend(ArrayNotation).extend(MethodMissingDispatchers)
  end

  # Decorates the given object 'obj' with a method 'name' that returns the
  # given 'element'. If 'name' is already taken, takes care of the array
  # folding behaviour.
  def self.add_child(obj, name, element) # :nodoc:
    key      = name.to_sym
    children = obj.instance_variable_get :@__children

    children[key] = if children[key]

      children[key] = [ children[key] ] unless children[key].is_a? Array
      children[key] << element
    else
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

    obj.instance_variable_set :@__attributes, attributes
    attr_value
  end
end