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
    if @target && duck.is_a?(Numeric)
      @__target[duck]

    elsif duck.is_a?(Hash)
      raise 'one and only one key allowed' if duck.keys.size != 1

      case param = duck.keys[0].to_sym
        when :elem then @__children[duck.values[0].to_sym]
        when :attr then @__attributes[duck.values[0].to_sym]
        else raise "Invalid key :#{param.to_s}. Use :elem or :attr"
      end
    else
      key = duck.to_s.to_sym

      case
        when @__children.has_key?(key)   then @__children[key]
        when @__attributes.has_key?(key) then @__attributes[key]
        else nil
      end
    end
  end
end