# frozen_string_literal: true

$:.unshift File.dirname(__FILE__)

require 'blackjack_ruby/version'
require 'blackjack_ruby/models/shoe'
require 'blackjack_ruby/models/card_value'
require 'blackjack_ruby/models/play'
require 'blackjack_ruby/models/hand'
require 'blackjack_ruby/models/dealer_hand'
require 'blackjack_ruby/models/player_hand'
require 'blackjack_ruby/models/hand_comparison'
require 'blackjack_ruby/models/player'
require 'blackjack_ruby/strategies/base'
require 'blackjack_ruby/strategies/pair_splitting_strategy'
require 'blackjack_ruby/strategies/hard_totals_strategy'

module BlackjackRuby
  class Error < StandardError; end
  # Your code goes here...
end
