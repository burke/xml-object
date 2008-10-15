module XMLStruct::ArrayNotation
  # Array-bracket (+[]+) notation access to elements and attributes. Use
  # when the element or attribute you need to reach is not reachable via dot
  # notation (because it's not a valid method name, or because the method
  # exists, such as +id+ or +class+).
  #
  # It also supports a hash key, which is used to reach attributes named
  # the same as elements in the same depth level (which otherwise go first)
  #
  # All of this is a lot easier to explain by example:
  #
  #   <article id="main_article" author="j-random">
  #     <author>J. Random Hacker</author>
  #   </article>
  #
  #   article.id                 => 9314390            # Object#id
  #   article[:id]               => "main_article"     # id attribute
  #   article[:author]           => "J. Random Hacker" # <author> element
  #   article[:attr => 'author'] => "j-random"         # author attribute
  #
  # Valid keys for the hash notation in the example above are +:attr+,
  # +:attribute+, +:child+, and +:element+.
  def [](name)
    return @__target[name] if @__target && name.is_a?(Numeric)

    unless name.is_a? Hash
      key = name.to_sym

      return @__children[key]   if @__children.has_key?(key)
      return @__attributes[key] if @__attributes.has_key?(key)
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