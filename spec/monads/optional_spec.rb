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
  end
end
