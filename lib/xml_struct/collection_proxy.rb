module XMLStruct
  class CollectionProxy < BlankishSlate
    def initialize(target)
      @__children, @__attributes, @__target = {}, {}, target
    end

    def method_missing(method, *args, &block)
      @__target.__send__(method, *args, &block) if @__target
    end
  end
end