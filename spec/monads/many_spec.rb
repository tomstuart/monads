require 'monads/many'

module Monads
  RSpec.describe 'the Many monad' do
    let(:values) { double }
    let(:many) { Many.new(values) }

    describe '#values' do
      it 'retrieves the values from a Many' do
        expect(many.values).to eq values
      end
    end
  end
end
