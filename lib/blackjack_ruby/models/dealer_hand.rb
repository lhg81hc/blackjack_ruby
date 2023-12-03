# frozen_string_literal: true

module BlackjackRuby
  module Models
    # Representing a dealer hand
    class DealerHand < Hand
      attr_accessor :up_card

      def initialize(cards)
        super
        @up_card = cards.first
      end

      def options
        {
          'stay' => can_stay?
        }
      end

      def enough?
        # TODO: Add option to include soft_seventeen? or not
        soft_seventeen? || hard_seventeen? || scores.any? { |s| s > 17 && s <= 21 }
      end

      def can_stay?
        blackjack? || bust? || enough?
      end

      def hard_seventeen?
        (more_than_two_cards? || (two_cards? && any_face_card_or_ten_card?)) && scores.any? { |s| s == 17 }
      end

      def soft_seventeen?
        two_cards? && any_ace_card? && scores.any? { |s| s == 17 }
      end
    end
  end
end
