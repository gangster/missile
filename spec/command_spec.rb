require 'spec_helper'

module Missile
  describe Command do
    context 'subclasses' do
      let(:subclass) do
         Class.new(Missile::Command) do
         end
       end

      let!(:dependencies) { double('dependencies', each: true) }

      before do
        allow(dependencies)
          .to receive(:[])
          .with(:dependencies)
          .and_return nil
      end

      it 'initializes with dependencies' do
        command = subclass.new(dependencies: dependencies)
        expect(command.dependencies).to eq dependencies
      end

      describe '#call' do
        subject { command.call }
        let(:command) { subclass.new}

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
        end
        context 'when error' do
          let(:subclass) do
            Class.new(Missile::Command) do
              def run
                # 😦
                errors.add(base: ['Fail!'])
              end
            end
          end
          it 'emits the error event' do
            expect { subject }.to broadcast(:error, command)
          end
        end
      end
    end
  end
end
