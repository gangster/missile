require 'spec_helper'

module Missile
  describe Errors do
    describe '#initialize' do
      subject { Errors.new.errors }
      it 'initializes an empty errors hash' do
        expect(subject).to eq({})
      end
    end

    describe '#add' do
      let(:errors) { Errors.new }
      context 'with valid arguments' do

        before do
          errors.add('SomeClass', :name, 'is required')
          errors.add('SomeClass', :name, 'is stupid')
          errors.add('SomeClass', :email, 'is invalid')
          errors.add('SomeOtherClass', :base, 'something blew up')
        end

        subject { errors.errors }

        it 'adds the error to the errors hash' do
          expect(subject).to eq({
            'SomeClass' => {
              name:  ['is required', 'is stupid'],
              email: ['is invalid']
            },
            'SomeOtherClass' => {
              base: ['something blew up']
            }
          })
        end
      end

      context 'without valid arguments' do
        context 'without a class name' do
          it 'raises an argument error' do
            expect { errors.add nil, :base, 'some message' }.to raise_error ArgumentError
          end
        end

        context 'without a field name' do
          it 'raises an argument error' do
            expect { errors.add nil, nil, 'some message' }.to raise_error ArgumentError
          end
        end

        context 'without a message' do
          it 'raises an argument error' do
            expect { errors.add nil, :base, nil }.to raise_error ArgumentError
          end
        end
      end
    end

    describe 'empty?' do
      it
    end

    describe 'empty!' do
      it
    end

    describe '[]' do
      it
    end

    describe '#to_h' do
      it
    end
  end
end
