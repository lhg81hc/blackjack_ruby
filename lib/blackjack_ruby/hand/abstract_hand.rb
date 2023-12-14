# frozen_string_literal: true

require 'blackjack_ruby/models/card_value'

module BlackjackRuby
  module Hand
    # Represent a hand in blackjack, can be player's hand or dealer's hand
    class AbstractHand
      TARGET_SCORE = 21

      attr_accessor :cards, :card_values

      def initialize(cards)
        @cards = cards
        @card_values = cards.map { |c| Models::CardValue.new(c) }
      end

      def blackjack?
        two_cards? && any_ace_card? && any_face_card_or_ten_card?
      end

      def best_score
        @best_score ||=
          begin
            best = scores.first

            scores.each do |s|
              best = s if (best > TARGET_SCORE && s <= TARGET_SCORE) || (s <= TARGET_SCORE && s > best)
            end

            best
          end
      end

      def bust?
        scores.all? { |s| s > TARGET_SCORE }
      end
      alias too_many? bust?

      # Eg:
      # 'A3' => [3, 13]
      # 'AA' => [2, 12, 22]
      # '54' => [9]
      def scores
        @scores ||= card_scores[0].product(*card_scores[1..]).map(&:sum).uniq
      end

      # Eg:
      # 'A3' => [[1, 11], [3]]
      # 'AA' => [[1, 11], [1, 11]]
      # '54' => [[5], [4]]
      def card_scores
        @card_scores ||= card_values.map(&:scores)
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
        card_values.map(&:rank).uniq.count == 1
      end

      def any_ace_card?
        card_values.any?(&:ace_card?)
      end

      def any_face_card_or_ten_card?
        card_values.any?(&:face_card_or_ten_card?)
      end

      def add_card(new_card)
        @cards << new_card
        @card_values << Models::CardValue.new(new_card)

        reset_memoized_values
      end

      private

      def reset_memoized_values
        @card_scores = nil
        @scores = nil
        @best_score = nil
      end
    end
  end
end
