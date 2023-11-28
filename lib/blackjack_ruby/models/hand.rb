module BlackjackRuby
  module Models
    class Hand
      BUST_VALUE = 21

      attr_reader :cards, :card_values

      def initialize(cards)
        @cards = cards
        @card_values = cards.map { |c| CardValue.new(c) }
      end

      def blackjack?
        return false unless cards.count == 2

        first_card_val = card_values[0]
        second_card_val = card_values[1]

        (first_card_val.ace_card? && second_card_val.face_card?) ||
          (first_card_val.face_card? && second_card_val.ace_card?)
      end

      def best_score
        best = scores.first.sum

        scores.each do |s|
          sum = s.sum
          next unless sum <= 21

          best = sum if sum > best
        end

        best
      end

      def busted?
        scores.all? { |s| s.sum > BUST_VALUE }
      end

      def scores
        individual_card_scores = card_values.map { |c| c.scores }

        first_card_scores = individual_card_scores[0]
        first_card_scores.product(*individual_card_scores[1..-1])
      end
    end
  end
end
