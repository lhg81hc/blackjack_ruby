# frozen_string_literal: true

require 'blackjack_ruby/config/option'
require 'blackjack_ruby/rule/dealer_hand'
require 'blackjack_ruby/rule/hand_comparison'
require 'blackjack_ruby/rule/player_hand'

module BlackjackRuby
  module Rule
    class Config
      class Builder
        attr_reader :config

        def initialize(config = Config.new, &block)
          @config = config
          instance_eval(&block) if block_given?
        end

        def build
          @config.validate! if @config.respond_to?(:validate!)
          @config
        end

        def self.builder_class
          Builder
        end

        extend BlackjackRuby::Config::Option

        option :dealer_hit_on_soft_seventeen,   default: BlackjackRuby::Rule::DealerHand::HIT_ON_SOFT_SEVENTEEN
        option :five_card_charlie,              default: BlackjackRuby::Rule::HandComparison::FIVE_CARD_CHARLIE
        option :player_bj_wins_automatically,   default: BlackjackRuby::Rule::HandComparison::PLAYER_BJ_WINS_AUTOMATICALLY
        option :player_21_wins_automatically,   default: BlackjackRuby::Rule::HandComparison::PLAYER_21_WINS_AUTOMATICALLY
        option :blackjack_payout_odds,          default: BlackjackRuby::Rule::PlayerHand::BLACKJACK_PAYOUT_ODDS
        option :maximum_cards_allow_double,     default: BlackjackRuby::Rule::PlayerHand::MAXIMUM_CARDS_ALLOW_DOUBLE
        option :maximum_double_per_betting_box, default: BlackjackRuby::Rule::PlayerHand::MAXIMUM_DOUBLE_PER_BETTING_BOX
      end
    end
  end
end
