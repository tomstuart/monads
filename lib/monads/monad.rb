module Monads
  module Monad
    private

    def ensure_monadic_result(&block)
      acceptable_result_type = self.class

      -> *a, &b do
        block.call(*a, &b).tap do |result|
          unless result.is_a?(acceptable_result_type)
            raise TypeError, "block must return #{acceptable_result_type.name}"
          end
        end
      end
    end
  end
end
