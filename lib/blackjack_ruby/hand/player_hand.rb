# frozen_string_literal: true

module BlackjackRuby
  module Hand
    # Represent a player hand
    class PlayerHand < AbstractHand
      attr_reader :initial_payout_odds

      attr_accessor :bet, :betting_box, :stayed, :split, :doubled, :surrendered

      def initialize(cards)
        super
        initialize_default_attributes
      end

      def doubled?
        @doubled
      end

      def stayed?
        @stayed
      end

      def split?
        @split
      end

      def surrendered?
        @surrendered
      end

      def twenty_one?
        scores.any? { |s| s == 21 }
      end

      def payout_odds
        blackjack? ? BlackjackRuby.config.blackjack_payout_odds.to_f : initial_payout_odds.to_f
      end

      def five_card_charlie?
        five_cards? && scores.any? { |s| s <= AbstractHand::TARGET_SCORE }
      end

      def any_score_under_21?
        scores.any? { |s| s < AbstractHand::TARGET_SCORE }
      end

      def any_score_over_10?
        scores.any? { |s| s > 10 }
      end

      def valid_number_of_cards_to_double?
        cards.count <= BlackjackRuby.config.maximum_cards_allow_double
      end

      def valid_to_split?
        two_cards? && identical_score_cards?
      end

      def valid_to_double?
        !blackjack? && !doubled? && any_score_under_21? && valid_number_of_cards_to_double?
      end

      def double_down
        @bet = @bet * 2
        @doubled = true
      end

      def surrender
        @bet = (@bet / 2).to_f
        @surrendered = true
      end

      alias hit_me add_card

      private

      def initialize_default_attributes
        @doubled = false
        @stayed = false
        @split = false
        @surrendered = false
        @initial_payout_odds = 1
        @bet = 0
        @betting_box = nil
      end
    end
  end
end
