module XMLObject::Element
  def self.new(xml) # :nodoc:
    element = xml.value
    element.instance_variable_set :@__raw_xml,    xml.raw
    element.instance_variable_set :@__children,   {}
    element.instance_variable_set :@__attributes, {}
    element.extend self
  end

  # The raw, unadapted XML object. Whatever this is, it really depends on
  # the currently chosen adapter.
  def raw_xml
    @__raw_xml
  end

  def has?(el, *a, &b)
    dispatched = __question_dispatch(m, *a, &b)
    dispatched = __dot_notation_dispatch(m, *a, &b) if dispatched.nil?
    
    return !!dispatched
  end

  def children
    @__children.keys
  end

  def attributes
    @__attributes.keys
  end

  private ##################################################################

  def method_missing(m, *a, &b) # :nodoc:
    dispatched = __question_dispatch(m, *a, &b)
    dispatched = __dot_notation_dispatch(m, *a, &b) if dispatched.nil?
  end
end
