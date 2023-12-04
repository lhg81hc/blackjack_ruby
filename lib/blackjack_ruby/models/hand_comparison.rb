# frozen_string_literal: true

module BlackjackRuby
  module Models
    # Evaluates Dealer Hand and Player Hand, assert who is the winner
    class HandComparison
      WINNER_TRANSLATIONS = {
        0 => 'Dealer',
        1 => 'Player',
        2 => 'Tie'
      }.freeze

      attr_reader :dealer_hand, :player_hand

      def initialize(dealer_hand: nil, player_hand: nil)
        @dealer_hand = dealer_hand
        @player_hand = player_hand

        validate
      end

      def both_blackjack?
        dealer_hand.blackjack? && player_hand.blackjack?
      end

      def same_best_score?
        !(dealer_hand.bust? || player_hand.bust?) &&
          !(dealer_hand.blackjack? || player_hand.blackjack?) &&
          (dealer_hand.best_score == player_hand.best_score)
      end

      def push?
        nil
      end

      alias tie? push?

      def winner
        if player_wins?
          return 1
        end

        if dealer_wins?
          return 0
        end

        if same_best_score?
          return 0
        end

        raise 'Can not decide who wins'
      end

      def dealer_wins?
        !player_wins_automatically? &&
          (
            player_hand.bust? ||
            (dealer_hand.blackjack? && !player_hand.blackjack?) ||
            (!dealer_hand.bust? && dealer_hand.best_score > player_hand.best_score)
          )
      end

      def winner_translation
        WINNER_TRANSLATIONS[winner]
      end

      def player_wins?
        player_wins_automatically? ||
          (!player_hand.bust? && dealer_hand.bust?) ||
          (!player_hand.bust? && !dealer_hand.bust? && player_hand.best_score > dealer_hand.best_score)
      end

      def player_wins_automatically?
        player_win_automatically_conditions.any?
      end

      def player_win_automatically_conditions
        [
          player_hand.five_card_charlie?,
          player_hand.blackjack?,
          player_hand.twenty_one?
        ]
      end

      def validate
        raise 'Dealer hand must be present' if dealer_hand.nil?
        raise 'Player hand must be present' if player_hand.nil?
      end
    end
  end
end
