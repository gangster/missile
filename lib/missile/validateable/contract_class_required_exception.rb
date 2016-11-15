module Missile
  module Validateable
    class ContractClassRequiredException < StandardError
      def initialize(msg = 'contract_class is required for validations.  Either pass it as a dependency in the constructor or #inject it when building the command object')
        super
      end
    end
  end
end
