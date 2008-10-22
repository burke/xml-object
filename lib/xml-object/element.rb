module XMLObject::Element
  def self.extended(obj) # :nodoc:
    obj.instance_variable_set :@__children,   {}
    obj.instance_variable_set :@__attributes, {}
    obj
  end

  # The raw, unadapted XML object. Whatever this is, it really depends on
  # the currently chosen adapter.
  def raw_xml
    @__raw_xml
  end

  private ##################################################################

  def method_missing(m, *a, &b) # :nodoc:
    dispatched = __question_dispatch(m, *a, &b)
    dispatched = __dot_notation_dispatch(m, *a, &b) if dispatched.nil?

    dispatched.nil? ? raise(NameError.new(m.to_s)) : dispatched
  end
end