module XMLStruct
  module String
    def self.extended(obj) # :nodoc:
      obj.instance_variable_set :@__children,   {}
      obj.instance_variable_set :@__attributes, {}
      obj
    end

    # Attempts to detect wether this String is really an integer or float,
    # and returns accordingly. If not, just returns the string.
    def rb
      @__rb ||= case
        when (self !~ /\S/)                          : nil
        when match(/[a-zA-Z]/)                       : ::String.new(self)
        when match(/^[+-]?\d+$/)                     : self.to_i
        when match(/^[+-]?(?:\d+(?:\.\d*)?|\.\d+)$/) : self.to_f
        else ::String.new(self)
      end
    end

    # A decorated String is blank when it has a blank value, no child
    # elements, and no attributes. For example:
    #
    #    <blank_element></blank_element>
    def blank?
      (self !~ /\S/) && @__children.blank? && @__attributes.blank?
    end

    def method_missing(method, *args, &block) # :nodoc:

      # Detect an existing method being called in question form:
      if method.to_s.match(/\?$/) && args.empty? && block.nil?
        boolish = send(method.to_s.chomp('?').to_sym).to_s

        %w[ true yes t y ].include? boolish.downcase
      end
    end

    def inspect # :nodoc:
      %{ #<#{self.class.to_s} (#{rb.inspect})
           attributes=[#{@__attributes.keys.map(&:to_s).join(', ') }]
           children=[#{@__children.keys.map(&:to_s).join(', ') }]> }.squish
    end
  end
end