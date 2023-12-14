# frozen_string_literal: true

module BlackjackRuby
  module Models
    # Represent a player hand
    class PlayerHand < Hand
      attr_writer :doubled
      attr_reader :initial_payout_odds
      attr_accessor :bet

      def initialize(cards)
        super

        @doubled = false
        @initial_payout_odds = 1
        @bet = 0
      end

      def options
        {
          'double' => can_double?,
          'hit' => can_hit?,
          'split' => can_split?,
          'stay' => true
        }
      end

      def can_split?
        two_cards? && identical_score_cards?
      end

      def can_hit?
        !blackjack? && !doubled? && scores.any? { |s| s < Hand::BUST_VALUE }
      end

      def can_double?
        can_hit? && (cards.count <= BlackjackRuby.config.maximum_cards_allow_double)
      end

      def doubled?
        @doubled
      end

      def twenty_one?
        scores.any? { |s| s == 21 }
      end

      def payout_odds
        blackjack? ? BlackjackRuby.config.blackjack_payout_odds.to_f : initial_payout_odds.to_f
      end
    end
  end
end
