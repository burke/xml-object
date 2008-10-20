module XMLObject::String

  # Attempts to detect wether this String is really an integer or float,
  # and returns accordingly. If not, just returns the string.
  def rb
    result = case
      when (self !~ /\S/)                          then ''
      when match(/[a-zA-Z]/)                       then ::String.new(self)
      when match(/^[+-]?\d+$/)                     then self.to_i
      when match(/^[+-]?(?:\d+(?:\.\d*)?|\.\d+)$/) then self.to_f
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
end