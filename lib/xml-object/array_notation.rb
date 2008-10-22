module XMLObject::ArrayNotation
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
  # Valid keys for the hash notation are +:attr+ and +:elem+.
  def [](duck)
    if @__target_kid && duck.is_a?(Numeric)
      @__children[@__target_kid][duck]
    elsif duck.is_a?(Hash)
      raise NameError.new('only one key allowed') if duck.keys.size != 1
      key, name = duck.keys[0].to_sym, duck.values[0].to_sym

      unless ( (key == :elem) || (:attr == key) )
        raise NameError.new("Invalid key :#{key.to_s}. Use :elem or :attr")
      end

      value = (key == :elem) ? @__children[name] : @__attributes[name]
      value.nil? ? raise(NameError.new(name.to_s)) : value
    else
      key = duck.to_s.to_sym

      case
        when (not @__children[key].nil?)   then @__children[key]
        when (not @__attributes[key].nil?) then @__attributes[key]
        else raise NameError.new(key.to_s)
      end
    end
  end
end