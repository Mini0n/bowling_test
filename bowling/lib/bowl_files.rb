# frozen_string_literal: true

require 'colorize'

# Reads & Parses bowling game files
class BowlFiles
  # Initialize
  # @bowled: bowling_file content
  def initialize(bowling_file)
    @bowled = load_file(bowling_file)
    byebug
  end

  def load_file(bowling_file)
    file = File.open(bowling_file)
    file.readlines.map(&:chomp).map { |line| line.split("\t") }
  rescue StandardError => e
    put_error("File \"#{bowling_file}\" couldn't be loaded: #{e.message}")
  end

  def parse_bowling_game
    return {} unless valid_bowled?(@bowled)

    hashed_throws = hash_by_player

    valid_throws?(hashed_throws) ? hashed_throws : {}
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

  def hash_by_player
    res = {}

    @bowled.each do |row|
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

  def put_error(message)
    puts "ERROR - #{message}".red
  end
end
