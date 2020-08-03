# frozen_string_literal: false

require_relative './bowl_errors'
require_relative './bowl_interface'

module BowlPrinterInterface
  extend BowlInterface
  method :print_game
end

class BowlPrinter
  include BowlErrors
  include BowlFilesInterface

  def initialize(bowling_game)
    @game = bowling_game
  end

  def print_game(bowling_game = @game)
    put_error('No game to print') if bowling_game.empty? || bowling_game.nil?

    @game = bowling_game

    @game.keys.each { |user| print_user_board(@game[user]) }

    # print_header
  end

  def print_user_board(user_game)
    print_header
    scores = print_pitfalls(user_game)
    print_scores(scores)
  end

  def print_scores(scores)
    line = '|          |'
    scores.each do |score|
      line += print_score(score)
    end
    puts "|#{'          |' * 11}"
    puts line
    print_separator(true, false)
  end

  def print_score(score)
    "#{score.to_s.center(10).light_yellow}|"
  end

  def print_pitfalls(user_game)
    scores = []
    line = "|#{print_user(user_game[:name].to_s).center(10)}|"
    # byebug
    user_game[:frames].each_with_index do |frame, i|
      line += print_balls(frame, i)
      scores << frame[-1]
    end
    puts line
    scores
  end

  def print_balls(frame, i = 0)
    play = "|#{print_ball(frame[0])} |#{print_ball(frame[1], frame[0])} |"
    if i < 9
      '    ' + play
    else
      play += "#{print_ball(frame[2])} |" if i === 9
      ' ' + play
    end
  end

  def print_ball(play, prev_play = nil)
    return 'F'.light_red if play === 'F'

    return 'X'.light_green if play === 10

    return ' ' if play.nil?

    if prev_play.nil? || prev_play === 'F'
      play
    else
      return '/'.light_blue if (play + prev_play) === 10

      play
    end
  end

  def print_user(name)
    return name if name.length <= 10

    name[0, 7] + '...'
  end

  def print_header
    print_separator
    numbers = (1..10).each_with_object('') { |n, s| s << "#{n.to_s.center(10)}|" }
    puts "|#{'name'.center(10)}|#{numbers}".white
    print_separator(false, true)
  end

  def print_separator(bottom = false, inter = false)
    separator = bottom ? "\'" : (inter ? '|' : '.')
    puts "#{separator}#{'——————————'"#{separator}" * 11}".white
  end
end
