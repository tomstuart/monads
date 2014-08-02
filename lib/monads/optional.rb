require 'monads/monad'

module Monads
  Optional = Struct.new(:value) do
    include Monad

    def and_then(&block)
      block = ensure_monadic_result(&block)

      if value.nil?
        self
      else
        block.call(value)
      end
    end

    def self.from_value(value)
      Optional.new(value)
    end
  end
end
