require 'wisper'
require 'ostruct'

module Missile
  class Command
    include Wisper::Publisher
    include Missile::Dependency::Injectable

    def initialize(dependencies: {})
      @value = nil
      @errors = Missile::Errors.new
      @befores = []
      @afters = []
      @dependencies = dependencies
      inject_dependencies if dependencies
    end

    attr_reader :dependencies, :value, :errors

    def call(*args)
      errors.empty!

      @befores.each do |callback|
        callback.call(*args)
      end

      begin
        @value = run(*args)
      rescue => e
        errors.add(:base, e.message)
      end

      if @value && @errors.empty?
        success!(self)
      else
        error!(self)
      end

      done!(self)

      @afters.each do |callback|
        callback.call(*args)
      end

      self
    end

    def and_return
      value
    end

    def before(&block)
      @befores << block
      self
    end

    def after(&block)
      @afters << block
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

    protected

    def success!(command)
      broadcast(:success, command)
    end

    def error!(command)
      broadcast(:error, command)
    end

    def done!(command)
      broadcast(:done, command)
    end

    # Deprecated in favor of #error!
    def fail!(command)
      broadcast(:failure, command)
    end

    def inject_dependencies
      @dependencies.each { |method, dep| inject(method, dep) }
    end

    private

    attr_reader :befores, :afters
  end
end
