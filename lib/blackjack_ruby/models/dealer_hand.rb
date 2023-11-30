module BlackjackRuby
  module Models
    class DealerHand < Hand
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
