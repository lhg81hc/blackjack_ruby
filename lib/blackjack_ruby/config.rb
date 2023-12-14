# frozen_string_literal: true

require 'blackjack_ruby/config/option'
require 'blackjack_ruby/config/attribute_accessors'
require 'blackjack_ruby/config/abstract_builder'
require 'blackjack_ruby/rule/dealer_hand'
require 'blackjack_ruby/rule/hand_comparison'
require 'blackjack_ruby/rule/player_hand'
require 'blackjack_ruby/rule/shoe'

module BlackjackRuby
  class Config
    class Builder < AbstractBuilder; end

    mattr_reader(:builder_class) { Builder }

    extend Option

    option :dealer_hits_on_soft_seventeen,     default: BlackjackRuby::Rule::DealerHand::HIT_ON_SOFT_SEVENTEEN
    option :five_card_charlie,                 default: BlackjackRuby::Rule::HandComparison::FIVE_CARD_CHARLIE
    option :player_bj_wins_automatically,      default: BlackjackRuby::Rule::HandComparison::PLAYER_BJ_WINS_AUTOMATICALLY
    option :player_21_wins_automatically,      default: BlackjackRuby::Rule::HandComparison::PLAYER_21_WINS_AUTOMATICALLY
    option :winner_when_same_best_score,       default: BlackjackRuby::Rule::HandComparison::WINNER_WHEN_SAME_BEST_SCORE
    option :blackjack_payout_odds,             default: BlackjackRuby::Rule::PlayerHand::BLACKJACK_PAYOUT_ODDS
    option :maximum_cards_allow_double,        default: BlackjackRuby::Rule::PlayerHand::MAXIMUM_CARDS_ALLOW_DOUBLE
    option :maximum_splitting_per_betting_box, default: BlackjackRuby::Rule::PlayerHand::MAXIMUM_SPLITTING_PER_BETTING_BOX
    option :number_of_decks,                   default: BlackjackRuby::Rule::Shoe::NUMBER_OF_DECKS
  end
end
