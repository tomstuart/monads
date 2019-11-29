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

      Many.new values.map(&block).map(&:values).flatten(1)
    end

    def respond_to_missing?(method_name, include_private = false)
      super || values.all? { |value| value.respond_to?(method_name, include_private) }
    end

    def self.from_value(value)
      if value.respond_to? :each
        Many.new(value)
      else
        Many.new([value])
      end
    end
  end
end
