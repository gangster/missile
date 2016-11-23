require 'wisper'
require 'ostruct'

module Missile
  class Command
    include Wisper::Publisher
    include Missile::Dependency::Injectable

    def initialize(dependencies: {})
      @value = nil
      @errors ||= Errors.new
      @befores = []
      @afters = []
      @dependencies = dependencies
      inject_dependencies if dependencies
    end

    attr_reader :dependencies, :value

    def call(*args)
      errors = {}

      befores.each { |callback| callback.call(*args) }

      self.value = run(*args)

      if value && errors.empty?
        broadcast(:success, self)
      else
        broadcast(:error, self)
      end

      broadcast(:done, self)

      afters.each { |callback| callback.call(*args) }

      self
    end

    def and_return
      value
    end

    def before(&block)
      befores << block
      self
    end

    def after(&block)
      afters << block
      self
    end

    def success(&block)
      on(:success, &block)
    end

    def error(&block)
      on(:error, &block)
    end

    def done(&block)
      on(:done, &block)
    end


    def errors
      @errors[self.class.name]
    end

    protected

    attr_writer :value

    def inject_dependencies
      dependencies.each { |method, dep| inject(method, dep) }
    end

    def error!(*args)
      if args.size == 1
        key = :base
      else
        key = args.first
      end
      message = args.last
      @errors.add(self.class.name, key, message)
      broadcast(:error, self)
      nil
    end

    private

    attr_reader :befores, :afters
  end
end
