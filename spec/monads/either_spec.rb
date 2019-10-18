# encoding: utf-8

require 'monads/either'

RSpec.describe Monads::Either do
  describe '::right' do
    subject { described_class.right(0) }
    it { is_expected.to be_right }
  end

  describe '::left' do
    subject { described_class.left(0) }
    it { is_expected.to be_left }
  end

  describe '#value' do
    subject { described_class.right(value) }
    let(:value) { 42 }

    it 'retrieves the value from an Either' do
      expect(subject.value).to eq value
    end
  end

  describe '#right?' do
    context 'given a right value' do
      subject { described_class.right(0) }
      it { is_expected.to be_right }
    end

    context 'given a left value' do
      subject { described_class.left(0) }
      it { is_expected.not_to be_right }
    end
  end

  describe '#left?' do
    context 'given a right value' do
      subject { described_class.right(0) }
      it { is_expected.not_to be_left }
    end

    context 'given a left value' do
      subject { described_class.left(0) }
      it { is_expected.to be_left }
    end
  end

  describe '#and_then' do
    context 'when the value is left' do
      subject { described_class.left(value) }
      let(:value) { "error" }

      it 'doesn’t call the block' do
        expect { |block| subject.and_then(&block) }.not_to yield_control
      end
    end

    context 'when the value is right' do
      subject { described_class.right(value) }
      let(:value) { 42 }

      it 'calls the block with the value' do
        @value = nil
        subject.and_then { |value| @value = value; described_class.right(double) }
        expect(@value).to eq value
      end

      it 'returns the block’s result' do
        result = double
        expect(subject.and_then { |value| described_class.right(result) }.value).to eq result
      end

      it 'raises an error if the block doesn’t return another Either' do
        expect { subject.and_then { double } }.to raise_error(TypeError)
      end
    end
  end
end
