# frozen_string_literal: true

module BlackjackRuby
  module Hand
    # Representing a dealer hand
    class DealerHand < AbstractHand
      attr_accessor :up_card

      def initialize(cards)
        super

        @up_card = cards.first
      end

      def enough?
        (soft_seventeen? && can_stay_on_soft_seventeen?) || hard_seventeen? || scores.any? { |s| s > 17 && s <= 21 }
      end

      def hard_seventeen?
        (more_than_two_cards? || (two_cards? && any_face_card_or_ten_card?)) && seventeen?
      end

      def soft_seventeen?
        two_cards? && any_ace_card? && seventeen?
      end

      def seventeen?
        scores.any? { |s| s == 17 }
      end

      def can_stay_on_soft_seventeen?
        !BlackjackRuby.config.dealer_hits_on_soft_seventeen
      end
    end
  end
end
