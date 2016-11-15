require 'spec_helper'

module Missile
  describe Validateable do
    let(:dependencies) do
      { contract_class: form_class, model: model }
    end

    describe '.contract' do
      context 'when passing contract class' do
        let!(:form_class) { Class.new(Reform::Form) }

        let(:command_class) do
          contract_class = form_class
          Class.new(Missile::Command) do
            include Validateable::Reform
            contract contract_class
          end
        end

        subject { command_class.new }

        it 'sets the contract_class class attribute' do
          expect(subject.class.contract_class).to eq form_class
        end
      end

      context 'when passing an inline form' do
        let(:command_class) do
          Class.new(Missile::Command) do
            include Validateable::Reform
            contract do
              feature Reform::Form::Dry

              validation do
                required(:name).filled
              end
            end
          end
        end

        subject { command_class.new.class.contract_class.new({}) }

        it 'dynamically instantiates a form object' do
          expect(subject).to be_a Reform::Form
        end
      end
    end

    describe '#validate' do
      let!(:form_class) { double(:form_class) }
      let(:form) { double(:form) }
      let!(:model) { double(:model) }
      let(:command_class) do
        Class.new(Missile::Command) do
          include Validateable::Reform

          def run(params)
            validate params do
              puts 'woot'
            end
            self
          end
        end
      end
      let(:dependencies) { { contract_class: form_class, model: model } }
      let(:params) { { name: 'test' } }

      before do
        allow(form_class).to receive(:new).with(model).and_return(form)
        allow(form).to receive(:validate).with(params).and_return(true)
      end

      context 'when dependencies are not present' do
        context 'when contract_class is not present' do
          let(:command) { command_class.new }
          subject { command.call(params) }
          it 'adds a ContractClassRequiredException message to the errors collection' do
            expect(subject.errors[:base].first).to eq 'contract_class is required for validations.  Either pass it as a dependency in the constructor or #inject it when building the command object'
          end
        end

        context 'when model is not present' do
          let(:command) { command_class.new(dependencies: { contract_class: form_class }) }
          subject { command.call(params) }
          it 'adds a ModelRequiredExeption message to the errors collection' do
            expect(subject.errors[:base].first).to eq 'model is required for validations.  Either pass it as a dependency in the constructor or #inject it when building the command object'
          end
        end
      end

      let(:command) { command_class.new(dependencies: dependencies) }

      context 'when successful' do
        let(:contract_errors) { double(:contract_errors, messages: {}) }

        before do
          allow(form_class).to receive(:new).with(model).and_return(form)
          allow(form).to receive(:validate).with(params).and_return(true)
          allow(form).to receive(:sync).and_return(true)
          allow(form).to receive(:errors).and_return(contract_errors)
        end

        it 'delegates #validate down to contract' do
          command.validate(params)
          expect(form).to have_received(:validate).with(params)
        end

        it 'yields the model' do
          expect { |b| command.validate(params, &b) }.to yield_with_args(model)
        end
      end

      context 'when failure' do
        let(:contract_errors) { double(:contract_errors, messages: { name: ["can't be blank"] }) }

        before do
          allow(form).to receive(:validate).with(params).and_return(false)
          allow(form).to receive(:errors).and_return(contract_errors)
        end

        it 'does not yield the model' do
          expect { |b| command.validate(params, &b) }.not_to yield_with_args(model)
        end

        it 'populates the errors collection' do
          command.validate(params)
          expect(command.errors.messages[:name]).to eq ["can't be blank"]
        end
      end
    end

    describe '#contract_for' do
      let!(:form_class) { Class.new(Reform::Form) }
      let(:form) { double(:form) }
      let!(:model) { double(:model) }
      let!(:dependencies) { { contract_class: form_class, model: model } }
      let(:command) { command_class.new(dependencies: dependencies) }

      before do
        allow(form_class)
          .to receive(:new)
          .with(model)
          .and_return(form)
      end

      context 'when contract_class is already set' do
        let(:command_class) do
          contract_class = form_class
          Class.new(Missile::Command) do
            include Validateable::Reform
            contract contract_class
          end
        end

        it 'returns an instance of the predfined contract_class' do
          expect(command.contract_for(nil, model)).to eq form
        end
      end

      context 'when passing in contract class' do
        let(:command_class) do
          Class.new(Missile::Command) do
            include Validateable::Reform
          end
        end
        it 'returns an instance of the passed in contract class' do
          expect(command.contract_for(form_class, model)).to eq form
        end
      end
    end
  end
end
