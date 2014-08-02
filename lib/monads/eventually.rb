module Monads
  Eventually = Struct.new(:block) do
    def initialize(&block)
      super(block)
    end

    def run(&success)
      block.call(success)
    end
  end
end
