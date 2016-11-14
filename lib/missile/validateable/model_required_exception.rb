module Missile
  module Validateable
    class ModelRequiredExeption < StandardError
      def initialize(msg="model is required for validations.  Either pass it as a dependency in the constructor or #inject it when building the command object")
        super
      end
    end
  end
end
