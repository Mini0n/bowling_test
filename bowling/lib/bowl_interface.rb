# frozen_string_literal: true

module Bowling
  module BowlInterface
    def method(name)
      define_method(name) { |*_args| raise "Interface error: method #{name} not implemented" }
    end
  end
end
