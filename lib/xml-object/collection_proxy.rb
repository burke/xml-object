class XMLObject::CollectionProxy < XMLObject::BlankishSlate # :nodoc:
  def initialize(target)
    @__children, @__attributes, @__target = {}, {}, target
  end

  private ##################################################################

  def method_missing(m, *a, &b) # :nodoc:
    dispatched = __question_dispatch(m, *a, &b)
    dispatched = __dot_notation_dispatch(m, *a, &b) if dispatched.nil?

    if dispatched.nil? && @__target.respond_to?(m)
      dispatched = @__target.__send__(m, *a, &b)

      unless dispatched.nil?
        instance_eval %{ def #{m}(*a, &b) @__target.#{m}(*a, &b); end }
      end
    end

    dispatched
  end
end