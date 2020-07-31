# frozen_string_literal: true

require 'byebug'
require 'awesome_print'
require 'colorize'

require './bowl_errors'
require './bowl_interface'
require './bowl_files'
require './bowl_game'
require './bowl_printer'

puts 'testing bowling...'.yellow

module Bowling
  test_1 = '/home/mini0n/Desktop/jobsity/sample1.txt'
  test_2 = '/home/mini0n/Desktop/jobsity/sample2.txt'
  test_3 = '/home/mini0n/Desktop/jobsity/sample3.txt'
  test_4 = '/home/mini0n/Desktop/jobsity/sample4.txt'
  test_5 = '/home/mini0n/Desktop/jobsity/sample5.txt'
  test_6 = '/home/mini0n/Desktop/jobsity/sample6.txt'

  # test = BowlFiles.new(test_3)
  # ap test.parse_bowling_game

  # test = BowlFiles.new(test_2)
  # ap test.parse_bowling_game

  files = BowlFiles.new(test_6)
  file_game = files.parse_bowling_game

  puts 'loaded game'.yellow
  ap file_game

  puts 'solving game...'.yellow
  game = BowlGame.new(file_game)
  solv = game.score_game

  puts 'solved game'.yellow
  ap solv

  puts 'print scoreboard...'.yellow
  screen = BowlPrinter.new(solv)
  screen.print_game

  byebug

  # byebug

  puts 'end'
end
