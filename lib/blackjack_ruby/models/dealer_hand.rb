module BlackjackRuby
  module Models
    class DealerHand < Hand
      def options
        if must_stay?
          return [0]
        end

        if must_hit?
          return [1]
        end

        raise "Unknown known hand: #{cards.map(&:to_encoded_unicode).join(' ')}"
      end

      def enough?
        scores.any? { |s| s >= 17 && s <= 21 }
      end

      def must_hit?
        !blackjack? && best_score < 17
      end

      def must_stay?
        blackjack? || busted? || enough?
      end

      def only_one_option?
        options.count == 1
      end
    end
  end
end
