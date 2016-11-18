module Missile
  class Errors
    attr_reader :errors

    def initialize(*args)
      if args[0]
        @errors = args[0]
      else
        @errors = {}
      end
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

    def to_h
      @errors
    end
    
    def [](name)
      @errors[name] || []
    end
  end
end
