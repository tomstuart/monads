module Monads
  Many = Struct.new(:values) do
    def and_then(&block)
      Many.new(values.map(&block).flat_map(&:values))
    end
  end
end
