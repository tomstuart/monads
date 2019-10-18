require 'monads/monad'

module Monads
  class Either
    include Monad

    attr_reader :value

    def initialize(right, value)
      @right = right
      @value = value
    end

    def self.right(value)
      new(true, value)
    end

    def self.left(value)
      new(false, value)
    end

    def right?
      @right
    end

    def left?
      !right?
    end

    def and_then(&block)
      block = ensure_monadic_result(&block)

      if right?
        block.call(value)
      else
        self
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      super || right? || value.respond_to?(method_name, include_private)
    end

    def self.from_value(value)
      Either.right(value)
    end
  end
end
