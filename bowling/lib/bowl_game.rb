# frozen_string_literal: true

require './bowl_errors'
require './bowl_interface'

class BowlGame
  def initialize(bowl_game = nil)
    @bowl_game = bowl_game
  end
end
