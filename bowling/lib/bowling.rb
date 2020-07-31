# frozen_string_literal: true

require 'byebug'
require 'awesome_print'
require 'colorize'

require './bowl_errors'
require './bowl_interface'
require './bowl_files'
require './bowl_game'
require './bowl_printer'

class Bowling
  def initialize
    @tests = test_files
    @cmd = nil
  end

  def test_files
    sample = './../../sample'
    test_files = 1.upto(6).map { |n| sample + n.to_s + '.txt' }
  end

  def run_tests
    @tests.each do |test|
      run_file(test)
    end
  end

  def run_file(bowl_file)
    puts "Running #{bowl_file}".green
    loaded = BowlFiles.new(bowl_file)
    parsed = loaded.parse_bowling_game
    played = BowlGame.new(parsed)
    scores = played.score_game
    screen = BowlPrinter.new(scores)
    screen.print_game
    # byebug
  end

  def start
    print_welcome
    run_tests
    byebug
  end

  def print_welcome
    puts ('-' * 43).to_s
    puts 'Welcome'.center(43)
    puts ('-' * 43).to_s
    puts '> Please choose an option'
    print_menu
  end

  def print_menu
    puts "[1] - Run tests files\n[2] - Run custom file"
  end

  # def run_program; end
end

# ------------------------------------------------------------------------------
#
# Program
#
# ------------------------------------------------------------------------------

bowl = Bowling.new
bowl.start
