require 'monads/eventually'

module Monads
  RSpec.describe 'the Eventually monad' do
    describe '#run' do
      it 'runs the block from an Eventually' do
        expect { |block| Eventually.new(&block).run }.to yield_control
      end

      it 'uses its block argument as a success callback' do
        @result, result = nil, double
        Eventually.new { |success| success.call(result) }.run { |value| @result = value }
        expect(@result).to eq result
      end
    end
  end
end
