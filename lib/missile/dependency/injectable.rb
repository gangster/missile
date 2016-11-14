module Missile
  module Dependency
    module Injectable
      attr_reader :dependencies

      def inject(method_name, dependency)
        dependencies[method_name] = dependency
        define_singleton_method(method_name) { dependency }
        self
      end
    end
  end
end
