# frozen_string_literal: true

require 'byebug'
require 'awesome_print'
require 'colorize'

require './bowl_errors'
require './bowl_interface'
require './bowl_files'

puts 'testing bowling...'

module Bowling
  test_1 = '/home/mini0n/Desktop/jobsity/sample1.txt'
  test_2 = '/home/mini0n/Desktop/jobsity/sample2.txt'
  test_3 = '/home/mini0n/Desktop/jobsity/sample3.txt'

  test = BowlFiles.new(test_3)
  ap test.parse_bowling_game

  test = BowlFiles.new(test_2)
  ap test.parse_bowling_game

  test = BowlFiles.new(test_1)
  ap test.parse_bowling_game

  # byebug

  puts 'end'
end
