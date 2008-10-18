module XMLObject::MethodMissingDispatchers # :nodoc:

  private ##################################################################

  def __question_dispatch(meth, *args, &block)
    return unless meth.to_s.match(/\?$/) && args.empty? && block.nil?

    method_sans_question = meth.to_s.chomp('?').to_sym

    if boolish = __send__(method_sans_question).downcase
      bool = case
        when %w[ true yes t y ].include?(boolish) then true
        when %w[ false no f n ].include?(boolish) then false
        else nil
      end

      unless bool.nil? # Fun, eh?
        instance_eval %{ def #{meth}; #{bool ? 'true' : 'false'}; end }
      end

      bool
    end
  end

  def __dot_notation_dispatch(meth, *args, &block)
    return unless args.empty? && block.nil?

    if @__children.has_key?(singular = meth.to_s.singularize.to_sym) &&
          @__children[singular].is_a?(Array)

      instance_eval %{ def #{meth}; @__children[%s|#{singular}|]; end }
      @__children[singular]

    elsif @__children.has_key?(meth)
      instance_eval %{ def #{meth}; @__children[%s|#{meth}|]; end }
      @__children[meth]

    elsif @__attributes.has_key?(meth)
      instance_eval %{ def #{meth}; @__attributes[%s|#{meth}|]; end }
      @__attributes[meth]
    end
  end
end