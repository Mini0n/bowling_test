# frozen_string_literal: true

require 'colorize'

# Reads & Parses bowling game files
class BowlFiles
  # Initialize
  # @errors: error catching hash
  # @bowl_file: bowling_file content
  def initialize(bowling_file)
    @bowl_file = load_file(bowling_file)
    byebug
  end

  def load_file(bowling_file)
    file = File.open(bowling_file)
    file.readlines.map(&:chomp)
  rescue StandardError => e
    puts "ERROR - File \"#{bowling_file}\" couldn't be loaded: #{e.message}".red
  end
end
