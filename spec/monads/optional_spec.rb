# encoding: utf-8

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

    describe '#within' do
      context 'when the value is nil' do
        before(:example) do
          allow(value).to receive(:nil?).and_return(true)
        end

        it 'doesn’t call the block' do
          expect { |block| optional.within(&block) }.not_to yield_control
        end
      end

      context 'when the value isn’t nil' do
        before(:example) do
          allow(value).to receive(:nil?).and_return(false)
        end

        it 'calls the block with the value' do
          expect { |block| optional.within(&block) }.to yield_with_args(value)
        end

        it 'returns the block’s result wrapped in an Optional' do
          result = double
          expect(optional.within { result }.value).to eq result
        end
      end
    end

    describe 'handling unrecognised messages' do
      let(:response) { double }

      before(:example) do
        allow(value).to receive(:challenge).and_return(response)
      end

      it 'forwards any unrecognised message to the value' do
        expect(value).to receive(:challenge)
        optional.challenge
        expect { optional.method(:challenge) }.not_to raise_error
        expect(optional).to respond_to(:challenge)
      end

      it 'returns the message’s result wrapped in an Optional' do
        expect(optional.challenge.value).to eq response
      end

      context 'when value is Enumerable' do
        let(:value) { [1, 2, 3] }

        it 'forwards any unrecognised message to the value' do
          expect(optional.first).to be_a(Optional)
          expect(optional.first.value).to eq 1
          expect(optional.last).to be_a(Optional)
          expect(optional.last.value).to eq 3
        end
      end
    end
  end
end
