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

    describe '#and_then' do
      context 'when the Eventually succeeds synchronously' do
        it 'arranges for the block to run when the Eventually succeeds' do
          @result, intermediate_result, final_result = nil, double, double
          Eventually.new { |success| success.call(intermediate_result) }.
            and_then do |value|
              if value == intermediate_result
                Eventually.new { |success| success.call(final_result) }
              end
            end.
            run { |value| @result = value }
          expect(@result).to eq final_result
        end

        it 'raises an error if the block doesn’t return another Eventually' do
          expect { Eventually.new { |success| success.call }.and_then { double }.run }.to raise_error(TypeError)
        end
      end

      context 'when the Eventually succeds asynchronously' do
        it 'arranges for the block to run when the Eventually succeeds' do
          @result, intermediate_result, final_result = nil, double, double
          Eventually.new { |success| @job = -> { success.call(intermediate_result) } }.
            and_then do |value|
              if value == intermediate_result
                Eventually.new { |success| success.call(final_result) }
              end
            end.
            run { |value| @result = value }
          @job.call
          expect(@result).to eq final_result
        end

        it 'raises an error if the block doesn’t return another Eventually' do
          expect {
            Eventually.new { |success| @job = -> { success.call } }.and_then { double }.run
            @job.call
          }.to raise_error(TypeError)
        end
      end
    end

    describe '.from_value' do
      let(:value) { double }

      it 'wraps a value in an Eventually' do
        @result = nil
        Eventually.from_value(value).run { |value| @result = value }
        expect(@result).to eq value
      end
    end
  end
end
