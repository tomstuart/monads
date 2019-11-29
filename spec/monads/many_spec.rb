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
      end

      it 'returns the messages’ results wrapped in a Many' do
        expect(many.challenge.values).to eq responses
      end

      context 'when all of the values respond to the message' do
        it 'reports that the Many responds to the message' do
          expect(many).to respond_to(:challenge)
        end

        it 'allows a Method object to be retrieved' do
          expect(many.method(:challenge)).to be_a(Method)
        end
      end

      context 'when any of the values don’t respond to the message' do
        let(:many) { Many.new(values + [double]) }

        it 'reports that the Many doesn’t respond to the message' do
          expect(many).not_to respond_to(:challenge)
        end

        it 'doesn’t allow a Method object to be retrieved' do
          expect { many.method(:challenge) }.to raise_error(NameError)
        end
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

    describe "unpacking nested many values" do
      let(:expected_values)   { %w(1984 Hamlet Macbeth) }
      let(:orwel_books)       { [double(:book, title: '1984')] }
      let(:shakespeare_books) { [double(:book, title: 'Hamlet'), double(:book, title: 'Macbeth')] }
      let(:values)            { [double(:orwell, books: orwel_books), double(:shakespeare, books: shakespeare_books)] }

      it { expect(many.books.title.values).to eq expected_values }
    end

    describe "respecting deeply nested arrays when unpacking only a few levels" do
      let(:expected_values)   { [:a, [:b, :c], :d, [:e, :f]] }
      let(:values)            { [[1, :a], [2, [:b, :c]], [3, :d], [4, [:e, :f]]] }

      it { expect(many.slice(1, 1).values).to eq expected_values }
    end
  end
end
