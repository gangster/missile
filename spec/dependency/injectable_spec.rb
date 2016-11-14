require 'spec_helper'

describe Missile::Dependency::Injectable do
  describe '.inject' do
    let(:command_class) do
      Class.new(Missile::Command)
    end

    subject { command_class.new({}) }

    it 'responds to inject' do
      expect(subject).to respond_to :inject
    end

    it 'exposes the dependencies attribute' do
      expect(subject).to respond_to :dependencies
    end

    context 'when injecting dependencies' do
      let(:command) { command_class.new({}) }
      let(:dependency) { double('bar') }
      let!(:injection ) { command.inject(:foo, dependency) }

      it 'returns self' do
        expect(injection).to eq command
      end

      context 'when inspecting the dependencies hash' do
        subject { command.dependencies }
        it 'adds the dependency to the dependencies hash' do
          expect(subject).to eq(foo: dependency)
        end
      end

      context 'when dynamically creating the accessor method' do
        subject { command }
        it 'exposes the method for accessing the dependency' do
          expect(command).to respond_to :foo
        end
      end
    end
  end
end
