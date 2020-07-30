# frozen_string_literal: true

require 'test'
require 'colorize'

RSpec.describe 'Test' do
  context '#ola' do
    it 'returns ola k ase' do
      test = Test.new

      puts test.to_s.light_green
      expect(test.ola).to eq 'ola k ase?'
    end
  end
end
