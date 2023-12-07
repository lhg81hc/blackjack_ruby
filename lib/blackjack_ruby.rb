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
require 'blackjack_ruby/strategies/soft_totals_strategy'
require 'blackjack_ruby/rule/config'

module BlackjackRuby
  class Error < StandardError; end

  class << self
    attr_accessor :rule_configuration

    def new
      @rule_configuration ||= Rule::Config::Builder.new
      Models::Play.new(@rule_configuration)
    end

    def configure
      @rule_configuration ||= Rule::Config::Builder.new
      yield(@rule_configuration)
    end
  end
end
