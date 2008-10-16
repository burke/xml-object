module XMLObject::String
  def self.extended(obj) # :nodoc:
    obj.instance_variable_set :@__children,   {}
    obj.instance_variable_set :@__attributes, {}
    obj
  end

  # Attempts to detect wether this String is really an integer or float,
  # and returns accordingly. If not, just returns the string.
  def rb
    result = case
      when (self !~ /\S/)                          : ''
      when match(/[a-zA-Z]/)                       : ::String.new(self)
      when match(/^[+-]?\d+$/)                     : self.to_i
      when match(/^[+-]?(?:\d+(?:\.\d*)?|\.\d+)$/) : self.to_f
      else ::String.new(self)
    end

    @__rb ||= result
  end

  # A decorated String is blank when it has a blank value, no child
  # elements, and no attributes. For example:
  #
  #    <blank_element></blank_element>
  def blank?
    (self !~ /\S/) && @__children.blank? && @__attributes.blank?
  end

  private ##################################################################

  def method_missing(m, *a, &b) # :nodoc:
    dp = __question_dispatch(m, *a, &b)
    dp = __dot_notation_dispatch(m, *a, &b) if dp.nil?
    dp
  end
end