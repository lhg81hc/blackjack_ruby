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
                     :betting_box, :blackjack?, :doubled?, :split?, :surrendered?, :two_cards?,
                     :any_score_over_10?, :any_score_under_21?,
                     :valid_number_of_cards_to_double?, :valid_to_split?,
                     :two_card?, :more_than_two_cards?

      def options
        r = []

        r << 'double' if can_double?
        r << 'hit' if can_hit?
        r << 'split' if can_split?
        r << 'stay' if can_stay?
        r << 'surrender' if can_surrender?

        r
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
        two_cards? || more_than_two_cards?
      end

      def dealer_up_card_value
        @dealer_upcard_value ||= Models::CardValue.new(dealer_up_card)
      end

      def can_surrender?
        two_cards? &&
          !doubled? &&
          !split? &&
          !surrendered? &&
          (
            (allowed_to_surrender_versus_2_to_9 && dealer_up_card_value.two_to_nine_card?) ||
              (allowed_to_surrender_versus_10 && dealer_up_card_value.face_card_or_ten_card?) ||
              (allowed_to_surrender_versus_ace && dealer_up_card_value.ace_card?)
          )

      end

      def allowed_to_surrender_versus_2_to_9
        BlackjackRuby.config.player_surrenders_versus_2_to_9
      end

      def allowed_to_surrender_versus_10
        allowed_to_late_surrender_versus_10 || allowed_to_early_surrender_versus_10
      end

      def allowed_to_late_surrender_versus_10
        BlackjackRuby.config.player_surrenders_versus_10 == 'late'
      end

      def allowed_to_early_surrender_versus_10
        BlackjackRuby.config.player_surrenders_versus_10 == 'early'
      end

      def allowed_to_surrender_versus_ace
        allowed_to_late_surrender_versus_ace || allowed_to_early_surrender_versus_ace
      end

      def allowed_to_late_surrender_versus_ace
        BlackjackRuby.config.player_surrenders_versus_ace == 'late'
      end

      def allowed_to_early_surrender_versus_ace
        BlackjackRuby.config.player_surrenders_versus_ace == 'early'
      end
    end
  end
end
