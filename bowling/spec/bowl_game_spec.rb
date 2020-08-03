# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BowlGame do
  before(:each) do
    @game = described_class.new
  end

  let(:test1) { { "Jeff": [10, 7, 3, 9, 0, 10, 0, 8, 8, 2, 'F', 6, 10, 10, 10, 8, 1] } }

  describe '#build_score_card' do
    it 'creates a score card hash for a given player & game' do
      card = @game.build_score_card('Jeff', test1[:Jeff])

      expect(card.class).to be(Hash)
      expect(card.keys).to eq(%i[name game total frames])
      expect(card[:name]).to eq('Jeff')
      expect(card[:game]).to eq(test1[:Jeff])
    end
  end

  describe '#fill_score_card' do
    it 'fills a score card hash with its game info' do
      card = @game.build_score_card('Jeff', test1[:Jeff])
      card = @game.fill_score_card(card)

      expected = [ # Expected Jeff solution
        [10, nil, nil], [7, 3, nil], [9, 0, nil], [10, nil, nil], [0, 8, nil],
        [8, 2, nil], ['F', 6, nil], [10, nil, nil], [10, nil, nil], [10, 8, 1, nil]
      ]

      expect(card[:frames]).to eq(expected)
    end
  end

  describe '#san_val' do
    it 'returns 0 for a Faul' do
      expect(@game.san_val('F')).to eq(0)
    end

    it 'returns 0 for a nil' do
      expect(@game.san_val(nil)).to eq(0)
    end
  end

  describe '#frame_sum' do
    context 'it calculates the sum for a played frame' do
      it 'calculates for a normal frame' do
        expect(@game.frame_sum([1, 2, nil])).to be 3
      end

      it 'calculates for a strike frame' do
        expect(@game.frame_sum([10, nil, nil])).to be 10
      end

      it 'calculates for a frame with a sum' do
        expect(@game.frame_sum([3, 'F', nil])).to be 3
      end
    end
  end

  describe '#is_normal?' do
    context 'a normal frame was played' do
      it 'returns true' do
        expect(@game.is_normal?([1, 3, 4])).to be true
      end
    end

    context 'a strike frame was played' do
      it 'returns false' do
        expect(@game.is_normal?([10, nil, 10])).to be false
      end
    end

    context 'a spare frame was played' do
      it 'returns false' do
        expect(@game.is_normal?([7, 3, 10])).to be false
      end
    end
  end

  describe '#is_spare?' do
    context 'a normal frame was played' do
      it 'returns true' do
        expect(@game.is_spare?([1, 3, 4])).to be false
      end
    end

    context 'not a strike frame was played' do
      it 'returns false' do
        expect(@game.is_spare?([10, nil, 10])).to be false
      end
    end

    context 'a spare frame was played' do
      it 'returns false' do
        expect(@game.is_spare?([7, 3, 10])).to be true
      end
    end
  end

  describe '#is_strike?' do
    context 'a normal frame was played' do
      it 'returns true' do
        expect(@game.is_strike?([1, 3, 4])).to be false
      end
    end

    context 'not a strike frame was played' do
      it 'returns false' do
        expect(@game.is_strike?([10, nil, 10])).to be true
      end
    end

    context 'a spare frame was played' do
      it 'returns false' do
        expect(@game.is_strike?([7, 3, 10])).to be false
      end
    end
  end

  describe '#grade_score_card' do
    it 'calculates the scores for a filled score card' do
      card = @game.build_score_card('Jeff', test1[:Jeff])
      card = @game.fill_score_card(card)
      card = @game.grade_score_card(card)

      expected = [ # expected results for Jeff
        [10, nil, 20], [7, 3, 39], [9, 0, 48], [10, nil, 66], [0, 8, 74],
        [8, 2, 84], ['F', 6, 90], [10, nil, 120], [10, nil, 148], [10, 8, 1, 167]
      ]

      expect(card[:frames]).to eq(expected)
    end
  end

  describe '#score_player' do
    it 'returns a filled and scored score card hash' do
      card = @game.score_player('Jeff', test1[:Jeff])

      expected = [ # expected results for Jeff
        [10, nil, 20], [7, 3, 39], [9, 0, 48], [10, nil, 66], [0, 8, 74],
        [8, 2, 84], ['F', 6, 90], [10, nil, 120], [10, nil, 148], [10, 8, 1, 167]
      ]

      expect(card[:name]).to eq('Jeff')
      expect(card[:total]).to eq(167)
      expect(card[:game]).to eq(test1[:Jeff])
      expect(card[:frames]).to eq(expected)
    end
  end

  describe '#score_game' do
    context 'a valid hashed game is passed' do
      it 'returns a hash of players with their filled & scored score card hashes' do
        game = @game.score_game(test1)

        expected = [ # expected results for Jeff
          [10, nil, 20], [7, 3, 39], [9, 0, 48], [10, nil, 66], [0, 8, 74],
          [8, 2, 84], ['F', 6, 90], [10, nil, 120], [10, nil, 148], [10, 8, 1, 167]
        ]

        expect(game.class).to be(Hash)
        expect(game.keys).to eq([:Jeff])
        expect(game[:Jeff][:frames]).to eq(expected)
      end
    end

    context 'an invalid hashed game is passed' do
      it 'returns a hash of players with their filled & scored score card hashes' do
        game = @game.score_game({ 'test' => nil })

        expected = [
          [nil, nil, 0], [nil, nil, 0], [nil, nil, 0], [nil, nil, 0],
          [nil, nil, 0], [nil, nil, 0], [nil, nil, 0], [nil, nil, 0],
          [nil, nil, 0], [nil, nil, nil, 0]
        ]

        expect(game.class).to be(Hash)
        expect(game['test'][:frames]).to eq(expected)

        game = @game.score_game({ 'test' => ['F'] })

        expected = [
          ['F', nil, 0], [nil, nil, 0], [nil, nil, 0], [nil, nil, 0],
          [nil, nil, 0], [nil, nil, 0], [nil, nil, 0], [nil, nil, 0],
          [nil, nil, 0], [nil, nil, nil, 0]
        ]

        expect(game.class).to be(Hash)
        expect(game['test'][:frames]).to eq(expected)
      end
    end

    context 'no hashed game is passed' do
      it 'returns an empty hash' do
        game = @game.score_game(nil)

        expect(game.class).to eq(Hash)
        expect(game.empty?).to be true
      end
    end
  end
end
