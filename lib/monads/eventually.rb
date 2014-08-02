module Monads
  Eventually = Struct.new(:block) do
    def initialize(&block)
      super(block)
    end

    def run(&success)
      block.call(success)
    end

    def and_then(&block)
      Eventually.new do |success|
        run do |value|
          block.call(value).run(&success)
        end
      end
    end
  end
end
