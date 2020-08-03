# frozen_string_literal: true

require 'spec_helper'
require 'colorize'

RSpec.describe BowlPrinter do
  before(:each) do
    @game = BowlGame.new.score_game(test1)
    @printer = described_class.new(@game)
  end

  let(:test1) { { "Jeff": [10, 7, 3, 9, 0, 10, 0, 8, 8, 2, 'F', 6, 10, 10, 10, 8, 1] } }

  describe '#print_separator' do
    it 'prints game' do
      expect { @printer.print_game }.to output(/.——————————.——————————.——————————.——————————.——————————.——————————.——————————.——————————.——————————.——————————.——————————./).to_stdout
      expect { @printer.print_game }.to output(/|   name   |    1     |    2     |    3     |    4     |    5     |    6     |    7     |    8     |    9     |    10    |/).to_stdout
      expect { @printer.print_game }.to output(%r{|   Jeff   |    |X |  |    |7 |/ |    |9 |0 |    |X |  |    |0 |8 |    |8 |/ |    |F |6 |    |X |  |    |X |  | |X |8 |1 |}).to_stdout
      expect { @printer.print_game }.to output(/|          |    20    |    39    |    48    |    66    |    74    |    84    |    90    |   120    |   148    |   167    |/).to_stdout
      expect { @printer.print_game }.to output(/|          |          |          |          |          |          |          |          |          |          |          |/).to_stdout
      expect { @printer.print_game }.to output(/'——————————'——————————'——————————'——————————'——————————'——————————'——————————'——————————'——————————'——————————'——————————'/).to_stdout
    end
  end
end
