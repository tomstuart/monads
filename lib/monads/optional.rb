module Monads
  Optional = Struct.new(:value) do
    def and_then(&block)
      if value.nil?
        self
      else
        block.call(value)
      end
    end
  end
end
