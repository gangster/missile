require 'spec_helper'

module Missile
  describe Validateable do

    describe '.contract' do
      context 'when passing contract class' do
        let!(:form) { Class.new(Reform::Form) }

        let(:command) do
          contract_class = form
          Class.new(Missile::Command) do
            include Validateable
            contract contract_class

            def run
            end
          end
        end

        subject { command.new({}) }
        it 'sets the contract_class class attribute' do
          expect(subject.class.contract_class).to eq form
        end
      end
      context 'when passing an inline form' do
        let(:command) do
          Class.new(Missile::Command) do
            include Validateable
            contract do
              validates :name, presence: true
            end

            def run
            end
          end
        end

        subject { command.new({}) }

        it 'dynamically instantiates a form object' do
          expect(subject.class.contract_class.new({})).to be_a Reform::Form
        end
      end
    end
  end
end
