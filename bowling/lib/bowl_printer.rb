# frozen_string_literal: true

require './bowl_errors'
require './bowl_interface'

module BowlPrinterInterface
  extend BowlInterface
  method :print_screen
end

class BowlPrinter
  include BowlErrors
  include BowlFilesInterface

  def initialize(bowling_game)
    @game = bowling_game
  end
end
