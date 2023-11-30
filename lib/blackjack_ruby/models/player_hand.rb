module BlackjackRuby
  module Models
    class PlayerHand < Hand
      attr_writer :doubled
      attr_reader :initial_payout_odds
      attr_accessor :bet, :stayed

      def initialize(cards)
        super

        @doubled = false
        @stayed = false
        @initial_payout_odds = 1
        @bet = 0
      end

      def options
        {
          'double' => can_double?,
          'hit' => can_hit?,
          'split' => can_split?,
          'stay' => true,
        }
      end

      def can_split?
        two_cards? && identical_score_cards?
      end

      def can_hit?
        !blackjack? && !doubled? && scores.any? { |s| s < Hand::BUST_VALUE }
      end

      def can_double?
        two_cards? && can_hit?
      end

      def doubled?
        @doubled
      end

      def payout_odds
        blackjack? ? (initial_payout_odds * 3 / 2) : initial_payout_odds
      end
    end
  end
end
