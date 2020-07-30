# frozen_string_literal: true

require './bowl_errors'
require './bowl_interface'

module BowlFilesInterface
  extend BowlInterface
  method :load_file
  method :parse_bowling_game
end

# Reads & Parses bowling game files
class BowlFiles
  include BowlErrors
  include BowlFilesInterface

  # Initialize
  def initialize(bowling_file)
    @bowl_file = bowling_file
    @bowl_game = nil
    @bowl_load = nil
  end

  def load_file(bowling_file)
    file = File.open(bowling_file)
    file.readlines.map(&:chomp).map { |line| line.split("\t") }
  rescue StandardError => e
    put_error("File \"#{bowling_file}\" couldn't be loaded: #{e.message}")
  end

  def parse_bowling_game(bowling_file = @bowl_file)
    @bowl_load = load_file(bowling_file) if @bowl_load.nil?

    return {} unless valid_bowled?(@bowl_load)

    @bowl_game = hash_by_player

    @bowl_game = valid_throws?(@bowl_game) ? @bowl_game : {}
  end

  # Check the number of throws by player are within limits
  def valid_throws?(hashed_throws)
    hashed_throws.keys.each do |key|
      if hashed_throws[key].length > 21 || hashed_throws[key].length < 12
        put_error("Invalid number of throws for player #{key}")
        return false
      end
    end
    true
  end

  # Parse the bowling game loaded contents into a hash of user => throws
  def hash_by_player
    res = {}

    @bowl_load.each do |row|
      player = row.first
      value = row.last

      if valid_value?(value)
        res.store(player, res.key?(player) ? res[player] << value : [value])
      else
        put_error("Invalid value found: #{value}")
        return {}
      end
    end
    res
  end

  # Checks pins down value is valid: F/f, or 0..10
  def valid_value?(value)
    return true if value === 'F' || value === 'f'

    value_int = Integer(value)

    value_int >= 0 && value_int <= 10
  rescue StandardError => e
    put_error("Invalid score value passed \"#{value}\": #{e.message}")
    false
  end

  # Checks the bowled information read from file is valid to be further parse
  def valid_bowled?(bowled)
    return false if bowled.nil?

    return false unless valid_file_rows?(bowled)

    true
  end

  # Checks the all rows from the bowled information is composed of two values
  def valid_file_rows?(rows)
    rows.each do |row|
      if row.length != 2
        put_error("Invalid row found: #{row}")
        return false
      end
    end
    true
  end
end
