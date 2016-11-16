require 'spec_helper'

module Missile
  describe Command do
    context 'subclasses' do
      let(:subclass) do
        Class.new(Missile::Command) do
        end
      end

      let!(:dependencies) { {} }

      it 'initializes with dependencies' do
        command = subclass.new(dependencies: dependencies)
        expect(command.dependencies).to eq dependencies
      end

      describe '#call' do
        subject { command.call }
        let(:command) { subclass.new }

        context 'when successful' do
          let(:subclass) do
            Class.new(Missile::Command) do
              def run
                @value = :foo
              end
            end
          end
          it 'emits the success event' do
            expect { subject }.to broadcast(:success, command)
          end
          it 'returns self' do
            expect(subject).to eq command
          end
        end
        context 'when error' do
          let(:subclass) do
            Object.const_set(
              'FooCommand',
              Class.new(Missile::Command) do
                def run
                  error!('Something bad happened!')
                end
              end
            )
            FooCommand
          end
          
          it 'emits the error event' do
            expect { subject }.to broadcast(:error, command)
          end
          it 'returns self' do
            expect(subject).to eq command
          end
        end
      end

      describe '#and_return' do
        let(:subclass) do
          Class.new(Missile::Command) do
            def run
              @value = :foo
            end
          end
        end
        let(:command) { subclass.new }

        subject { command.call.and_return }

        it 'returns the value' do
          expect(subject).to eq :foo
        end
      end

      describe '#before' do
        let(:subclass) do
          Class.new(Missile::Command) do
            def run
              @value = :foo
            end
          end
        end

        let(:command) { subclass.new }

        subject { command.before {} }

        it 'returns self' do
          expect(subject).to eq command
        end

        it 'adds a block to the private befores collection to be executed later' do
          expect { subject }.to change { command.send(:befores).size }.from(0).to(1)
        end
      end

      describe '#after' do
        let(:subclass) do
          Class.new(Missile::Command) do
            def run
              @value = :foo
            end
          end
        end

        let(:command) { subclass.new }
        subject { command.after }

        it 'returns self' do
          expect(subject).to eq command
        end

        it 'adds a block to the private afters collection to be executed later' do
          expect { subject }.to change { command.send(:afters).size }.from(0).to(1)
        end
      end

      describe '#success' do
        let(:subclass) do
          Class.new(Missile::Command) do
            def run
              @value = :foo
            end
          end
        end

        let(:command) { subclass.new }
        subject { command.success {} }

        it 'returns self' do
          expect(subject).to eq command
        end

        it 'adds a listener' do
          expect { subject }.to change { command.listeners.size }.from(0).to(1)
        end
      end

      describe '#error' do
        let(:subclass) do
          Class.new(Missile::Command) do
            def run
              errors.add(:base, 'foo')
            end
          end
        end

        let(:command) { subclass.new }

        subject { command.error {} }

        it 'returns self' do
          expect(subject).to eq command
        end

        it 'adds a listener' do
          expect { subject }.to change { command.listeners.size }.from(0).to(1)
        end
      end

      describe '#done' do
        let(:subclass) do
          Class.new(Missile::Command) do
            def run
            end
          end
        end

        let(:command) { subclass.new }

        subject { command.done {} }

        it 'returns self' do
          expect(subject).to eq command
        end

        it 'adds a listener' do
          expect { subject }.to change { command.listeners.size }.from(0).to(1)
        end
      end

      describe '#errors' do
        let(:subclass) do
          Class.new(Missile::Command) do
            def run
            end
          end
        end

        let(:command) { subclass.new }
        let(:errors) { Errors.new }
        subject { command.errors }

        context 'when no arguments are passed' do
          it 'returns the errors collection' do
            expect(subject).to eq []
          end
        end
      end

      describe '#error' do
        let(:subclass) do
          Object.const_set(
            'FooCommand',
            Class.new(Missile::Command) do
              def run
                error!('Something bad happened!')
              end
            end
          )
          FooCommand
        end

        let(:command) { subclass.new }

        before do
          command.call
        end

        it 'adds the error to the collection' do
          expect(command.errors).to eq({ base: ['Something bad happened!'] })
        end
      end
    end
  end
end
