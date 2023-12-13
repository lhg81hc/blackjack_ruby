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

      def winner
        if player_wins?
          return 1
        end

        if dealer_wins?
          return 0
        end

        if same_best_score? || both_blackjack?
          return BlackjackRuby.config.winner_when_same_best_score
        end

        raise 'Can not decide who wins'
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

      def dealer_wins?
        player_hand.bust? ||
          dealer_hand_is_bj_when_player_hand_is_not ||
          (!dealer_hand.bust? && dealer_hand_best_score_is_closer_to_21)
      end

      def winner_translation
        WINNER_TRANSLATIONS[winner]
      end

      def player_wins?
        player_wins_automatically? ||
          player_hand_is_bj_when_dealer_hand_is_not ||
          dealer_hand_is_busted_when_player_hand_is_not ||
          (dealer_hand_and_player_hand_are_both_not_busted && player_hand_best_score_is_closer_to_21)
      end

      def player_wins_automatically?
        player_wins_automatically_conditions.any?
      end

      def player_wins_automatically_conditions
        conditions = []
        conditions << player_hand.five_card_charlie? if BlackjackRuby.config.five_card_charlie
        conditions << player_hand.blackjack? if BlackjackRuby.config.player_bj_wins_automatically
        conditions << player_hand.twenty_one? if BlackjackRuby.config.player_21_wins_automatically

        conditions
      end

      def dealer_hand_is_busted_when_player_hand_is_not
        dealer_hand.bust? && !player_hand.bust?
      end

      def dealer_hand_and_player_hand_are_both_not_busted
        !player_hand.bust? && !dealer_hand.bust?
      end

      def player_hand_best_score_is_closer_to_21
        player_hand.best_score > dealer_hand.best_score
      end

      def dealer_hand_best_score_is_closer_to_21
        dealer_hand.best_score > player_hand.best_score
      end

      def dealer_hand_is_bj_when_player_hand_is_not
        dealer_hand.blackjack? && !player_hand.blackjack?
      end

      def player_hand_is_bj_when_dealer_hand_is_not
        player_hand.blackjack? && !dealer_hand.blackjack?
      end

      def validate
        raise 'Dealer hand must be present' if dealer_hand.nil?
        raise 'Player hand must be present' if player_hand.nil?
      end
    end
  end
end
