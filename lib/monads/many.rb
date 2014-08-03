require 'monads/monad'

module Monads
  Many = Struct.new(:values) do
    include Monad

    def and_then(&block)
      block = ensure_monadic_result(&block)

      Many.new(values.flat_map { |*args| block.call(*args).values })
    end

    def self.from_value(value)
      Many.new([value])
    end
  end
end
