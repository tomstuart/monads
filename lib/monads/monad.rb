module Monads
  module Monad
    def within(&block)
      and_then do |value|
        self.class.from_value(block.call(value))
      end
    end

    def method_missing(*args, &block)
      within do |value|
        value.public_send(*args, &block)
      end
    end

    def respond_to_missing?(method_name, include_private=false)
      within do |value|
        value.respond_to?(method_name, include_private)
      end || super
    end

    private

    def ensure_monadic_result(&block)
      acceptable_result_type = self.class

      ->(*a, &b) do
        block.call(*a, &b).tap do |result|
          unless result.is_a?(acceptable_result_type)
            raise TypeError, "block must return #{acceptable_result_type.name}"
          end
        end
      end
    end
  end
end
