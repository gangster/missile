module Missile
  class Errors

    attr_reader :errors

    def initialize(*)
      @errors = {}
    end

    def add(class_name, field = :base, message)
      if class_name.nil? || field.nil? || message.nil?
        raise ArgumentError
      end
      @errors[class_name] ||= {}
      @errors[class_name][field] ||= []
      @errors[class_name][field] << message
    end

    def empty?
      @errors.empty?
    end

    def empty!
      @errors = {}
    end

    # needed by Rails form builder.
    def [](name)
      @errors[name] || []
    end

    def to_h
      @errors
    end
  end
end
