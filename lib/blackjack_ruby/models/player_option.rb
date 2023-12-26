# frozen_string_literal: true

module BlackjackRuby
  module Models
    class PlayerOption
      extend Forwardable

      attr_reader :dealer_up_card, :player_hand

      def initialize(dealer_up_card, player_hand)
        @dealer_up_card = dealer_up_card
        @player_hand = player_hand
      end

      def_delegators :@player_hand,
                     :betting_box, :blackjack?, :doubled?, :split?, :two_cards?,
                     :any_score_over_10?, :any_score_under_21?,
                     :valid_number_of_cards_to_double?, :valid_to_split?

      def options
        {
          'double' => can_double?,
          'hit' => can_hit?,
          'split' => can_split?,
          'stay' => can_stay?,
          'surrender' => can_surrender?
        }
      end

      def can_split?
        valid_to_split? && betting_box.total_hands <= BlackjackRuby.config.maximum_splitting_per_betting_box
      end

      def can_hit?
        !blackjack? && !doubled? && any_score_under_21?
      end

      def can_double?
        can_hit? && valid_number_of_cards_to_double?
      end

      def can_stay?
        any_score_over_10?
      end

      def can_surrender?
        two_cards? && !doubled? && !split? && Models::CardValue.new(dealer_up_card).ace_card?
      end
    end
  end
end
