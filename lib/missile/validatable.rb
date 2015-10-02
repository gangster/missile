require 'uber/inheritable_attr'
require 'reform'
require 'reform/form/active_model/model_validations'

module Missile
  module Validatable
    attr_reader :contract
    def self.included(base)
      base.instance_eval do
        extend Uber::InheritableAttr
        inheritable_attr :contract_class

        self.contract_class = Reform::Form.clone
        self.contract_class.class_eval do
          include Reform::Form::ActiveModel::Validations
          def self.name # FIXME: don't use ActiveModel::Validations in Reform, it sucks.
            # for whatever reason, validations climb up the inheritance tree and require _every_ class to have a name (4.1).
            "Reform::Form"
          end
        end

        def contract(*contract_class, &block)
          if block_given?
            self.contract_class.class_eval(&block)
          else
            self.contract_class = contract_class[0]
          end
        end
      end
    end

    def validate(params, entity, contract_class=nil)
      @contract = contract_for(contract_class, entity)
      if @valid = validate_contract(params)
        contract.sync
        yield entity if block_given?
      else
        broadcast(:failure, { errors: @contract.errors.messages })
      end
      @valid
    end

    def validate_contract(params)
      contract.validate(params)
    end

    # Instantiate the contract, either by using the user's contract passed into #validate
    # or infer the Command contract.
    def contract_for(contract_class, *entity)
      (contract_class || self.class.contract_class).new(*entity)
    end
  end
end
