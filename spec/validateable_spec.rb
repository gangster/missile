require 'spec_helper'

module Missile
  describe Validateable do

    describe '.contract' do
      context 'when passing contract class' do
        let!(:form) { Class.new(Reform::Form) }

        let(:command_class) do
          contract_class = form
          Class.new(Missile::Command) do
            include Validateable
            contract contract_class
          end
        end

        subject { command_class.new({}) }
        it 'sets the contract_class class attribute' do
          expect(subject.class.contract_class).to eq form
        end
      end
      context 'when passing an inline form' do
        let(:command_class) do
          Class.new(Missile::Command) do
            include Validateable
            contract do
              validates :name, presence: true
            end
          end
        end

        subject { command_class.new({}).class.contract_class.new({}) }

        it 'dynamically instantiates a form object' do
          expect(subject).to be_a Reform::Form
        end
      end
    end

    describe '#validate' do
      let!(:form_class) { double(:form_class) }
      let(:form) { double(:form) }
      let!(:entity) { double(:entity) }
      let(:command_class) do
        contract_class = form_class
        Class.new(Missile::Command) do
          include Validateable
          contract contract_class
        end
      end
      let(:params) { { name: 'test' } }
      let(:command) { command_class.new(name: 'test') }

      context 'when successful' do
        before do
          allow(form_class).to receive(:new).with(entity).and_return(form)
          allow(form).to receive(:validate).with(params).and_return(true)
          allow(form).to receive(:sync).and_return(true)
        end

        it 'delegates #validate down to contract' do
          command.validate(params, entity)
          expect(form).to have_received(:validate).with(params)
        end

        it 'yields the entity when successful' do
          expect { |b| command.validate(params, entity, &b) }.to yield_with_args(entity)
        end
      end

      context 'when failure' do

      end
    end

    describe '#contract_for' do
      let!(:form_class) { Class.new(Reform::Form) }
      let(:form) { double(:form) }
      let!(:entity) { double(:entity) }
      let(:command) { command_class.new(name: 'test') }

      before do
        allow(form_class)
          .to receive(:new)
          .with(entity)
          .and_return(form)
      end

      context 'when contract_class is already set' do
        let(:command_class) do
          contract_class = form_class
          Class.new(Missile::Command) do
            include Validateable
            contract contract_class
          end
        end

        it 'returns an instance of the predfined contract_class' do
          expect(command.contract_for(nil, entity)).to eq form
        end
      end

      context 'when passing in contract class' do
        let(:command_class) do
          Class.new(Missile::Command) do
            include Validateable
          end
        end
        it 'returns an instance of the passed in contract class' do
          expect(command.contract_for(form_class, entity)).to eq form
        end
      end
    end
  end
end
