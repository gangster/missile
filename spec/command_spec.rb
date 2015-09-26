require 'spec_helper'

module Missile
  describe Command do
    context 'abstract methods' do
      let(:command) { Command.new({}) }
      describe '#run' do
        it 'raises an error' do
          expect { command.run }.to raise_error NotImplementedError
        end
      end
    end
    context 'subclasses' do
      let(:subclass) do
         Class.new(Missile::Command) do
           def has_params?
             !params.nil?
           end
         end
       end
      let(:params) { double('params') }
      it 'initializes with params' do
        command = subclass.new(params)
        expect(command.has_params?).to eq true
      end

      describe '#run' do
        context 'when successful' do
          context 'when passing a no arguments to success!' do
            let(:subclass) do
              Class.new(Missile::Command) do
                def run
                  success!
                end
              end
            end
            it 'emits the success event' do
              command = subclass.new(double(:params))
              expect { command.run }.to broadcast(:success)
            end
          end
          context 'when passing a single argument to success!' do
            let(:subclass) do
              Class.new(Missile::Command) do
                def run
                  success! "thing"
                end
              end
            end
            it 'emits the success event' do
              command = subclass.new(double(:params))
              expect { command.run }.to broadcast(:success, "thing")
            end
          end
          context 'when passing multiple arguments to success!' do
            let(:subclass) do
              Class.new(Missile::Command) do
                def run
                  success! "thing1", "thing2"
                end
              end
            end
            it 'emits the success event' do
              command = subclass.new(double(:params))
              expect { command.run }.to broadcast(:success, "thing1", "thing2")
            end
          end
        end
        context 'when failed' do
          context 'when passing a no arguments to fail!' do
            let(:subclass) do
              Class.new(Missile::Command) do
                def run
                  fail!
                end
              end
            end
            it 'emits the failed event' do
              command = subclass.new(double(:params))
              expect { command.run }.to broadcast(:failure)
            end
          end
          context 'when passing a single argument to fail!' do
            let(:subclass) do
              Class.new(Missile::Command) do
                def run
                  fail! "thing"
                end
              end
            end
            it 'emits the failed event' do
              command = subclass.new(double(:params))
              expect { command.run }.to broadcast(:failure, "thing")
            end
          end
          context 'when passing multiple arguments to fail!' do
            let(:subclass) do
              Class.new(Missile::Command) do
                def run
                  fail! "thing1", "thing2"
                end
              end
            end
            it 'emits the failed event' do
              command = subclass.new(double(:params))
              expect { command.run }.to broadcast(:failure, "thing1", "thing2")
            end
          end
        end
      end
    end
  end
end
