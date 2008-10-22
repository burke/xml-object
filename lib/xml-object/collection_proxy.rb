class XMLObject::CollectionProxy < XMLObject::BlankishSlate # :nodoc:
  def initialize(target_kid_key)
    @__children, @__attributes, @__target_kid = {}, {}, target_kid_key
  end

  private ##################################################################

  def method_missing(m, *a, &b) # :nodoc:
    dispatched = __question_dispatch(m, *a, &b)
    dispatched = __dot_notation_dispatch(m, *a, &b) if dispatched.nil?

    if dispatched.nil? && @__children[@__target_kid].respond_to?(m)
      dispatched = @__children[@__target_kid].__send__(m, *a, &b)

      unless dispatched.nil?
        instance_eval %{ def #{m}(*a, &b);
          @__children[@__target_kid].#{m}(*a, &b); end }
      end
    end

    dispatched
  end
end