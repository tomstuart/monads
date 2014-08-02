require 'monads/optional'

module Monads
  RSpec.describe 'the Optional monad' do
    let(:value) { double }
    let(:optional) { Optional.new(value) }

    describe '#value' do
      it 'retrieves the value from an Optional' do
        expect(optional.value).to eq value
      end
    end

    describe '#and_then' do
      context 'when the value is nil' do
        before(:example) do
          allow(value).to receive(:nil?).and_return(true)
        end

        it 'doesn’t call the block' do
          expect { |block| optional.and_then(&block) }.not_to yield_control
        end
      end

      context 'when the value isn’t nil' do
        before(:example) do
          allow(value).to receive(:nil?).and_return(false)
        end

        it 'calls the block with the value' do
          @value = nil
          optional.and_then { |value| @value = value; Optional.new(double) }
          expect(@value).to eq value
        end

        it 'returns the block’s result' do
          result = double
          expect(optional.and_then { |value| Optional.new(result) }.value).to eq result
        end

        it 'raises an error if the block doesn’t return another Optional' do
          expect { optional.and_then { double } }.to raise_error(TypeError)
        end
      end
    end

    describe '.from_value' do
      it 'wraps a value in an Optional' do
        expect(Optional.from_value(value).value).to eq value
      end
    end
  end
end
