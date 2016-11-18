require 'spec_helper'

module Missile
  describe Errors do
    let(:errors) { Errors.new }
    describe '#initialize' do
      subject { Errors.new.errors }
      it 'initializes an empty errors hash' do
        expect(subject).to eq({})
      end
    end

    describe '#add' do
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
      subject { errors.empty? }
      context 'when no errors are present' do
        it 'is true' do
          expect(subject).to eq true
        end
      end

      context 'when errors are present' do
        before do
          errors.add('SomeClass', :name, 'is required')
        end
        it 'is false' do
          expect(subject).to eq false
        end
      end
    end

    describe 'empty!' do
      before do
        errors.add('SomeClass', :name, 'is required')
      end

      it 'clears the error hash' do
        expect(errors.empty?).to eq false
        errors.empty!
        expect(errors.empty?).to eq true
      end
    end

    describe '[]' do
      it
    end
  end
end
