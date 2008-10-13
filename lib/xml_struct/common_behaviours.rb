module XMLStruct::CommonBehaviours

  # Detect an existing method being called in question form:
  def __question_answer(method, *args, &block)
    if method.to_s.match(/\?$/) && args.empty? && block.nil?
      boolish = __send__(method.to_s.chomp('?').to_sym).to_s

      return true  if %w[ true yes t y ].include? boolish.downcase
      return false if %w[ false no f n ].include? boolish.downcase
    end
  end

  # Array-notation access to elements and attributes. It comes handy when
  # the element or attribute you need to reach is not reachable via dot
  # notation (because it's not a valid method name, or because the method
  # exists, such as 'id' or 'class').
  #
  # It also supports hash keys, which are useful to reach attributes named
  # the same as elements in the same level (which otherwise go first)
  #
  # All of this is a lot easier to exampling by example:
  #
  #   <article id="main_article" author="j-random">
  #     <author>J. Random Hacker</author>
  #   </article>
  #
  #   article.id                 => 9314390         # Object#id gets called
  #   article[:id]               => "main_article"  # id attribute
  #   article[:author]           => <XMLStruct ...> # <author> element
  #   article[:attr => 'author'] => "j-random"      # author attribute
  #
  # Valid keys for the hash notation in the example above are :attr,
  # :attribute, :child, and :element.
  def [](name)
    return @__target[name] if @__target && name.is_a?(Numeric)

    unless name.is_a? Hash
      return @__children[name.to_sym]   if @__children[name.to_sym]
      return @__attributes[name.to_sym] if @__attributes[name.to_sym]
    end

    raise 'one and only one key allowed' if name.size != 1

    case (param = name.keys.first.to_sym)
      when :element   : @__children[name.values.first.to_sym]
      when :child     : @__children[name.values.first.to_sym]
      when :attr      : @__attributes[name.values.first.to_sym]
      when :attribute : @__attributes[name.values.first.to_sym]
      else raise %{ Invalid key :#{param.to_s}.
        Use one of :element, :child, :attr, or :attribute }.squish!
    end
  end
end