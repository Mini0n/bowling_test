# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BowlFiles do
  before(:each) do
    @files = described_class.new
  end

  let(:test1) { './../sample1.txt' } # valid file
  let(:test2) { './../sample2.txt' } # invalid file

  describe '#load_file' do
    context 'reading a valid file' do
      it 'reads a valid file' do
        loaded = @files.load_file(test1)

        expect(loaded.class).to eq(Array) # file rows
        expect(loaded.length).to eq(35) # file rows length
        expect(loaded.first.class).to eq(Array) # file row
        expect(loaded.first.length).to eq(2) # row values length
      end
    end

    context 'reading an invalid file' do
      it 'reads a non-existent file' do
        expect { @files.load_file(test1 + 'bad') }.not_to raise_error
      end
    end
  end

  describe '#parse_bowling_game' do
    context 'parsing a valid file' do
      it 'parses a valid file' do
        parsed = @files.parse_bowling_game(test1)

        expect(parsed.class).to eq(Hash)
        expect(parsed.keys).to eq(%w[Jeff John])
      end
    end

    context 'parsing an invalid file' do
      it 'parses a file with invalid info' do
        parsed = @files.parse_bowling_game(test2)

        expect(parsed.class).to eq(Hash)
        expect(parsed.empty?).to be true
      end
    end
  end

  context '#hash_by_player' do
    it 'creates a hash of players and throws for a bowling file' do
      parsed = @files.parse_bowling_game(test1)
      hashed = @files.hash_by_player

      expect(hashed.class).to be(Hash)
      expect(hashed.keys).to eq(%w[Jeff John]) # Keys are the players
      expect(hashed.to_a.first.last.length).to eq(17) # Throws for 1st player
      expect(hashed.to_a.last.last.length).to eq(18) # Throws for 2nd player
    end
  end

  describe '#valid_throws?' do
    context 'a valid number of throws per player' do
      it 'has the max amount of ball-throws' do
        hashed = { 'test': Array.new(21) { '1' } }

        expect(@files.valid_throws?(hashed)).to be true
      end

      it 'has the min amount of ball-throws' do
        hashed = { 'test': Array.new(12) { '1' } }

        expect(@files.valid_throws?(hashed)).to be true
      end
    end

    context 'an invalid number of throws per player' do
      it 'has to many ball-throws' do
        hashed = { 'test': Array.new(22) { '1' } }

        expect(@files.valid_throws?(hashed)).to be false
      end

      it 'has to little ball-throws' do
        hashed = { 'test': Array.new(11) { '1' } }

        expect(@files.valid_throws?(hashed)).to be false
      end
    end
  end

  describe '#valid_value?' do
    context 'value is a valid play value' do
      it 'validates a valid integer' do
        expect(@files.valid_value?(3)).to be true
      end

      it 'validates the max valid integer' do
        expect(@files.valid_value?(10)).to be true
      end

      it 'validates a fault' do
        expect(@files.valid_value?('F')).to be true
      end
    end

    context 'value is anvalid play value' do
      it 'validates a negative' do
        expect(@files.valid_value?(-43)).to be false
      end

      it 'validates an invalid string' do
        expect(@files.valid_value?('AB')).to be false
      end
    end
  end
end
