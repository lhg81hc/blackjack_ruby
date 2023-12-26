# frozen_string_literal: true

$:.unshift File.dirname(__FILE__)

require 'blackjack_ruby/version'
require 'blackjack_ruby/models/shoe'
require 'blackjack_ruby/models/card_value'
require 'blackjack_ruby/models/play'
require 'blackjack_ruby/hand/abstract_hand'
require 'blackjack_ruby/hand/dealer_hand'
require 'blackjack_ruby/hand/player_hand'
require 'blackjack_ruby/models/hand_comparison'
require 'blackjack_ruby/strategies/base'
require 'blackjack_ruby/strategies/pair_splitting_strategy'
require 'blackjack_ruby/strategies/hard_totals_strategy'
require 'blackjack_ruby/strategies/soft_totals_strategy'
require 'blackjack_ruby/strategies/finder'
require 'blackjack_ruby/config'
require 'blackjack_ruby/models/betting_box'
require 'blackjack_ruby/models/round'
require 'blackjack_ruby/models/player_option'
require 'blackjack_ruby/models/dealer_option'

module BlackjackRuby
  class Error < StandardError; end

  class << self
    def configure(&block)
      @config = Config::Builder.new(&block).build
    end

    # @return [BlackjackRuby::Config] configuration instance
    #
    def configuration
      @config || configure
    end

    def configured?
      !@config.nil?
    end

    alias config configuration

    def play_auto(number_of_games: 1)
      BlackjackRuby::Models::Play.new.auto(number_of_games: number_of_games)
    end
  end
end
