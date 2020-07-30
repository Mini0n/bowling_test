# frozen_string_literal: true

require 'colorize'

module Bowling
  module BowlErrors
    def put_error(message)
      add_to_errors(message)
      puts "ERROR - #{message}".red
    end

    def add_to_errors(message)
      @errors = [] if @errors.nil?
      @errors << message
    end
  end
end
