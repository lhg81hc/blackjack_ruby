module BlackjackRuby
  module Models
    class Hand
      BUST_VALUE = 21

      attr_accessor :cards, :card_values
      attr_accessor :cards, :card_values, :stayed

      def initialize(cards)
        @cards = cards
        @card_values = cards.map { |c| CardValue.new(c) }
        @stayed = false
      end

      def blackjack?
        two_cards? && any_ace_card? && any_face_card_or_ten_card?
      end

      def five_card_charlie?
        five_cards? && scores.any? { |s| s <= 21 }
      end

      def best_score
        @best_score ||=
          begin
            best = scores.first

            scores.each do |s|
              if best > 21 && s <= 21
                best = s
              elsif s <= 21 && s > best
                best = s
              end
            end

            best
          end
      end

      def bust?
        scores.all? { |s| s > BUST_VALUE }
      end

      alias :too_many? :bust?

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

      def more_than_two_cards?
        cards.count > 2
      end

      def five_cards?
        cards.count == 5
      end

      def pair?
        two_cards? && identical_rank_cards?
      end

      def soft?
        two_cards? && any_ace_card? && !blackjack?
      end

      def identical_score_cards?
        card_scores.uniq.count == 1
      end

      def identical_rank_cards?
        @card_values.map(&:rank).uniq.count == 1
      end

      def any_ace_card?
        card_values.any? { |cv| cv.ace_card? }
      end

      def any_face_card_or_ten_card?
        card_values.any? { |cv| cv.face_card_or_ten_card? }
      end

      # 'Hit me!'
      def add_card(new_card)
        @cards << new_card
        @card_values << CardValue.new(new_card)

        # Reset memoized values
        @card_scores = nil
        @scores = nil
        @best_score = nil
      end
    end
  end
end
