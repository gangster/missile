require 'wisper'
require 'ostruct'

module Missile
  class Command
    include Wisper::Publisher

    def initialize(params)
      @params = params
      @errors = OpenStruct.new(messages: [])
    end

    def run
      fail NotImplementedError, 'Implement #run in subclass'
    end

    private

    attr_reader :params, :errors

    def success!(*args)
      broadcast(:success, *args)
    end

    def fail!(*args)
      broadcast(:failure, *args)
    end

    def error(message, error = nil)
      errors.messages << message
    end
  end
end
