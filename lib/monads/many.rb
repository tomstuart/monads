require 'monads/monad'

module Monads
  class Many
    include Monad

    attr_reader :values

    def initialize(values)
      @values = values
    end

    def and_then(&block)
      block = ensure_monadic_result(&block)

      Many.new(values.map(&block).flat_map(&:values))
    end

    def respond_to_missing?(method_name, include_private = false)
      super || values.all? { |value| value.respond_to?(method_name, include_private) }
    end

    def self.from_value(value)
      Many.new([value])
    end
  end
end
