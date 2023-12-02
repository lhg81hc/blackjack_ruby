module BlackjackRuby
  module Models
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
        !player_hand.five_card_charlie? &&
          !(dealer_hand.bust? || player_hand.bust?) &&
          !(dealer_hand.blackjack? || player_hand.blackjack?) &&
          dealer_hand.best_score == player_hand.best_score
      end

      def push?
        both_blackjack? || same_best_score?
      end

      alias :tie? :push?

      def winner
        if dealer_wins?
          0
        elsif push?
          2
        else # Player wins
          1
        end
      end

      def dealer_wins?
        !player_wins? &&
          (
            player_hand.bust? ||
            (!player_hand.blackjack? && dealer_hand.blackjack?) ||
            (!dealer_hand.bust? && dealer_hand.best_score > player_hand.best_score)
          )
      end

      def winner_translation
        WINNER_TRANSLATIONS[winner]
      end

      def player_wins?
        player_hand.five_card_charlie?
      end

      def validate
        raise "Dealer hand and Player hand must be present" if dealer_hand.nil? || player_hand.nil?
      end
    end
  end
end
