module XMLObject::Element
  def self.extended(obj) # :nodoc:
    obj.instance_variable_set :@__children,   {}
    obj.instance_variable_set :@__attributes, {}
    obj
  end

  # The raw, unadapted XML object. Whatever this is, it really depends on
  # the current_adapter.
  def raw_xml
    @__adapted_element.raw if @__adapted_element
  end

  private ##################################################################

  def method_missing(m, *a, &b) # :nodoc:
    dp = __question_dispatch(m, *a, &b)
    dp = __dot_notation_dispatch(m, *a, &b) if dp.nil?
    dp
  end
end