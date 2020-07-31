# frozen_string_literal: true

require 'spec_helper'
require 'byebug'
# require 'bowl_files'
# require 'bowl_errors'
# require 'bowl_interfaces'

RSpec.describe BowlFiles do
  let(:files) { described_class.new }
  let(:the_file) { File.read('spec/example1.txt') }

  #   let(:video) do
  #     'Video	8
  # Video	2
  # Video	7
  # Video	3
  # Video	3
  # Video	4
  # Video	10
  # Video	2
  # Video	8
  # Video	10
  # Video	10
  # Video	8
  # Video	F
  # Video	10
  # Video	8
  # Video	2
  # Video	9
  # '
  #   end

  describe '#load_file' do
    context 'it reads a valid file' do
      it 'reads a valid file' do
        puts 'to be solved'
        byebug
      end
    end

    context 'it read an invalid file' do
    end
  end

  context '#parse_bowling_game' do
  end

  context '#valid_throws?' do
  end

  context '#hash_by_player' do
  end

  describe '#valid_value?' do
    context 'value is a valid play value' do
      it 'validates a valid integer' do
        expect(files.valid_value?(3)).to be true
      end

      it 'validates the max valid integer' do
        expect(files.valid_value?(10)).to be true
      end

      it 'validates a fault' do
        expect(files.valid_value?('F')).to be true
      end
    end

    context 'value is anvalid play value' do
      it 'validates a negative' do
        expect(files.valid_value?(-43)).to be false
      end

      it 'validates an invalid string' do
        expect(files.valid_value?('AB')).to be false
      end
    end
  end

  context '#valid_bowled?' do
  end

  context '#valid_file_rows?' do
  end
end
