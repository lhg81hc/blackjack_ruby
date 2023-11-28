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
        return false unless two_cards?

        any_ace_card? && any_face_card?
      end

        (first_card_val.ace_card? && second_card_val.face_card?) ||
          (first_card_val.face_card? && second_card_val.ace_card?)
      end

      def best_score
        @best_score ||=
          begin
            best = scores.first

            scores.each do |s|
              best = s if s <= 21 && s > best
            end

            best
          end
      end

      def busted?
        scores.all? { |s| s > BUST_VALUE }
      end

      # Eg:
      # 'A3' => [3, 13]
      # 'AA' => [2, 12, 22]
      # '54' => [9]
      def scores
        @scores ||=
          card_scores[0].
          product(*card_scores[1..-1]).
          map(&:sum).
          uniq
      end

      # Eg:
      # 'A3' => [[1, 11], [3]]
      # 'AA' => [[1, 11], [1, 11]]
      # '54' => [[5], [4]]
      def card_scores
        @card_scores ||= card_values.map { |c| c.scores }
      end

      def two_cards?
        cards.count == 2
      end

      def any_ace_card?
        card_values.any? { |cv| cv.ace_card? }
      end

      def any_face_card?
        card_values.any? { |cv| cv.face_card? }
      end
    end
  end
end
