# encoding: utf-8

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

        it 'raises an error if the block doesn’t return another Many' do
          expect { many.and_then { double } }.to raise_error(TypeError)
        end
      end
    end

    describe '.from_value' do
      let(:value) { double }

      it 'wraps a value in a Many' do
        expect(Many.from_value(value).values).to eq [value]
      end
    end

    describe '#within' do
      context 'when there aren’t any values' do
        let(:values) { [] }

        it 'doesn’t call the block' do
          expect { |block| many.within(&block) }.not_to yield_control
        end
      end

      context 'when there are values' do
        let(:values) { [1, 2, 3] }

        it 'calls the block with each value' do
          expect { |block| many.within(&block) }.to yield_successive_args(*values)
        end

        it 'returns a flattened version of the block’s results wrapped in a Many' do
          expect(many.within { |value| value * 2 }.values).to eq [2, 4, 6]
        end
      end
    end

    describe 'handling unrecognised messages' do
      let(:values) { [double, double, double] }
      let(:responses) { [double, double, double] }

      before(:example) do
        values.zip(responses) do |value, response|
          allow(value).to receive(:challenge).and_return(response)
        end
      end

      it 'forwards any unrecognised message to each value' do
        values.each do |value|
          expect(value).to receive(:challenge)
        end
        many.challenge
        expect { many.method(:challenge) }.not_to raise_error
        expect(many).to respond_to(:challenge)
      end

      it 'returns the messages’ results wrapped in a Many' do
        expect(many.challenge.values).to eq responses
      end

      context 'when values are Enumerable' do
        let(:values) { [[1, 2], [3, 5]] }

        it 'forwards any unrecognised message to the value' do
          expect(many.first).to be_a(Many)
          expect(many.first.values).to eq [1, 3]
          expect(many.last).to be_a(Many)
          expect(many.last.values).to eq [2, 5]
        end
      end
    end
  end
end
