require 'wepo/repo'
require 'wepo/adapters/active_record'

module Missile
  module Persistable
    module Wepo
      def self.included(base)
        base.instance_eval do
          extend Uber::InheritableAttr
          inheritable_attr :repo_class

          self.repo_class = Class.new do
            include ::Wepo::Repo
          end

          def self.repo(*args, &block)
            if block_given?
              self.repo_class.class_eval(&block)
            else
              self.repo_class = args[0]
            end
          end
        end
      end

      def repo
        @repo ||= self.class.repo_class.new(::Wepo::Adapters::ActiveRecord)
      end

    end
  end
end