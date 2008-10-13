class XMLStruct::CollectionProxy < XMLStruct::BlankishSlate
  def initialize(target)
    @__children, @__attributes, @__target = {}, {}, target
  end

  def method_missing(m, *a, &b) # :nodoc:
    answer = __question_answer(m, *a, &b)
    answer.nil? ? (@__target.__send__(m, *a, &b) if @__target) : answer
  end
end