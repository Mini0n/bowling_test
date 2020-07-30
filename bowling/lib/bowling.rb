# frozen_string_literal: true

require 'byebug'
require 'awesome_print'
require 'colorize'

require './bowl_files'

puts 'testing bowling...'

archivo = '/home/mini0n/Desktop/jobsity/sample1.txt'

test = BowlFiles.new(archivo)

byebug

puts 'end'
