require 'monads/many'

module Monads
  RSpec.describe 'the Many monad' do
    let(:many) { Many.new(values) }

    describe '#values' do
      let(:values) { double }

      it 'retrieves the values from a Many' do
        expect(many.values).to eq values
      end
    end

    describe '#and_then' do
      context 'when there aren’t any values' do
        let(:values) { [] }

        it 'doesn’t call the block' do
          expect { |block| many.and_then(&block) }.not_to yield_control
        end
      end

      context 'when there are values' do
        let(:values) { [1, 2, 3] }

        it 'calls the block with each value' do
          @values = []
          many.and_then { |value| @values << value; Many.new(double) }
          expect(@values).to eq values
        end

        it 'returns a flattened version of the block’s results' do
          expect(many.and_then { |value| Many.new(value * 2) }.values).to eq [2, 4, 6]
        end
      end
    end
  end
end
