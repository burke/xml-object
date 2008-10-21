class XMLObject::CollectionProxy < XMLObject::BlankishSlate # :nodoc:
  def initialize(target)
    @__children, @__attributes, @__target = {}, {}, target
  end

  private ##################################################################

  def method_missing(m, *a, &b) # :nodoc:
    dispatched = __question_dispatch(m, *a, &b)
    dispatched = __dot_notation_dispatch(m, *a, &b) if dispatched.nil?
    dispatched = __target_dispatch(m, *a, &b)       if dispatched.nil?
    dispatched
  end
end