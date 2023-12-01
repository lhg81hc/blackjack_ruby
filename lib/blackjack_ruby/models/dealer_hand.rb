module BlackjackRuby
  module Models
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
        scores.any? { |s| s >= 17 && s <= 21 }
      end

      def can_stay?
        blackjack? || busted? || enough?
      end
    end
  end
end
