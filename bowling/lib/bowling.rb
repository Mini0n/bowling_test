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
  end

  def start
    print_welcome
    # run_tests
    # byebug
    wait_command
  end

  def wait_command
    res = gets.chomp
    unless res === '3'
      if res === '1'
        run_tests
      else
        ask_file
      end

      print_menu

      wait_command
    end
  end

  def ask_file
    puts 'Please input the filename full path to be scored:'.purple
    filename = gets.chomp
    run_file(filename)
  end

  def print_welcome
    puts ('-' * 43).to_s
    puts 'Welcome'.center(43)
    puts ('-' * 43).to_s
    print_menu
  end

  def print_menu
    puts '> Please choose an option (all but 1 or 3 is 2)'
    puts "[1] - Run tests files\n[2] - Run custom file\n[3] - Exit"
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
