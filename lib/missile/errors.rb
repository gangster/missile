module Missile
  class Errors
    def initialize(*)
      @errors = {}
    end

    module Merge
      def merge!(errors, prefix)
        errors.messages.each do |field, msgs|
          unless field.to_sym == :base
            field = (prefix + [field]).join('.').to_sym # TODO: why is that a symbol in Rails?
          end

          msgs.each do |msg|
            next if messages[field] && messages[field].include?(msg)
            add(field, msg)
          end # Forms now contains a plain errors hash. the errors for each item are still available in item.errors.
        end
      end

      def to_s
        messages.inspect
      end
    end
    include Merge

    def add(field, message)
      @errors[field] ||= []
      @errors[field] << message
    end

    def add_all(messages)
      messages.each do |field, messages|
        messages.each do |message|
          add field, message
        end
      end
    end

    def messages
      @errors
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
  end
end