require 'uber/inheritable_attr'
require 'reform'
require "reform/form/active_model/validations"
require 'reform/form/dry'

module Missile
  module Validateable
    module Reform
      attr_reader :contract
      def self.included(base)
        base.instance_eval do
          extend Uber::InheritableAttr
          inheritable_attr :contract_class

          self.contract_class = ::Reform::Form.clone

          def self.contract(*contract_klass, &block)
            if block_given?
              self.contract_class.class_eval(&block)
            else
              self.contract_class = contract_klass[0]
            end
          end
        end
      end

      def validate(params)
        raise ContractClassRequiredException unless respond_to?(:contract_class)
        raise ModelRequiredExeption unless respond_to?(:model)

        @contract = contract_for(contract_class, model)
        if validate_contract(params)
          contract.sync
          yield model if block_given?
        else
          errors.add_all(contract.errors.messages)
        end
        self
      end

      def valid?
        errors.empty?
      end

      def validate_contract(params)
        contract.validate(params)
      end

      # Instantiate the contract, either by using the user's contract passed into #validate
      # or infer the  contract.
      def contract_for(contract_class, *model)
        (contract_class || self.class.contract_class).new(*model)
      end
    end
  end
end
