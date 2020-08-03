# frozen_string_literal: true

require_relative './bowl_errors'
require_relative './bowl_interface'

module BowlGameInterface
  extend BowlInterface
  method :score_game
end

class BowlGame
  include BowlErrors
  include BowlFilesInterface

  def initialize(bowling_game = nil)
    @bowl_game = bowling_game
  end

  def score_game(bowling_game = @bowl_game)
    if bowling_game.nil? || bowling_game.empty?
      put_error('Game is empty. Nothing to score')
      return {}
    end

    @bowl_game = bowling_game

    results = {}

    @bowl_game.keys.each do |player|
      results[player] = score_player(player, @bowl_game[player])
    end

    results
  end

  def score_player(player, game)
    puts "Scoring player #{player} for #{game}".green
    card = build_score_card(player, game)
    card = fill_score_card(card)
    grade_score_card(card)
  end

  def grade_score_card(card)
    card[:total] = 0

    card[:frames].each do |frame|
      frame[-1] = frame_sum(frame)
    end

    card[:frames].each_with_index do |frame, i|
      if is_strike?(frame)
        frame[-1] = calc_strike(frame, i, card, 0)
        card[:total] = frame[-1]
        next
      end

      if is_spare?(frame)
        frame[-1] = calc_spare(frame, i, card)
        card[:total] = frame[-1]
        next
      end

      frame[-1] += card[:total]
      card[:total] = frame[-1]
    end
    card
  end

  def is_strike?(frame)
    frame.last === 10 && frame[1].nil?
  end

  def is_spare?(frame)
    frame.last === 10 && !frame[1].nil?
  end

  def is_normal?(frame)
    frame.last < 10
  end

  # when a strike, it's the sum of the strike plus that o the next two balls
  def calc_strike(frame, i, card, strike_count = 0, temp = 0)
    if (i + 1) < 9
      next_frame = card[:frames][i + 1]

      if is_normal?(next_frame) || is_spare?(next_frame)
        frame[-1] + card[:total] + next_frame.last + temp

      else # another strike
        if strike_count < 2
          calc_strike(next_frame, i + 1, card, strike_count + 1, frame[-1])
        else
          card[:total] + 30
        end
      end
    else
      if temp === 0
        frame[-1] + card[:total] + san_val(card[:frames].last[0]) + san_val(card[:frames].last[1])
      else
        frame[-1] + card[:total] + san_val(card[:frames].last[0]) + temp
      end
    end
  end

  # get score value when a score is done
  def calc_spare(frame, i, card)
    if i < 9
      next_frame = card[:frames][i + 1]
      frame[-1] += card[:total] + san_val(next_frame.first)
    end
  end

  # calculate the sum for a value
  def frame_sum(frame)
    res = 0
    frame.each do |val|
      res += san_val(val)
    end
    res
  end

  # sanitize value for integer operations
  def san_val(value)
    return 0 if value === 'F' || value.nil?

    value
  end

  # fill the score card with the game ball values
  def fill_score_card(card)
    game = card[:game] || {}
    return card if game.empty?

    frames = card[:frames]
    frame = 0
    ball = 0

    game.each do |play|
      if play === 10 && frame < 9
        frames[frame][ball] = play
        frame += 1
        ball = 0
        next
      end

      if ball == 1 && frame < 9
        frames[frame][ball] = play
        frame += 1
        ball = 0
        next
      end

      frames[frame][ball] = play
      ball += 1
    end
    card
  end

  # build score card hash
  def build_score_card(player, game)
    {
      name: player,
      game: game,
      total: nil,
      frames: Array.new(9) { Array.new(3) { nil } } .push([nil, nil, nil, nil])
    }
  end
end
