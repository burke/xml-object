class XMLObject::CollectionProxy < XMLObject::BlankishSlate # :nodoc:
  def initialize(target)
    @__children, @__attributes, @__target = {}, {}, target
  end

  private ##################################################################

  def method_missing(m, *a, &b) # :nodoc:
    dp = __question_dispatch(m, *a, &b)
    dp = __dot_notation_dispatch(m, *a, &b) if dp.nil?
    dp = @__target.__send__(m, *a, &b) if @__target.respond_to?(m) && dp.nil?
    dp
  end
end