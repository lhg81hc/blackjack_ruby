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
        !(dealer_hand.busted? || player_hand.busted?) &&
          !(dealer_hand.blackjack? || player_hand.blackjack?) &&
          dealer_hand.best_score == player_hand.best_score
      end

      def push?
        both_blackjack? || same_best_score?
      end

      alias :tie? :push?

      def winner
        # return 0 if player_hand.busted?
        # return 1 if player_hand.blackjack?
        # return 1 if !player_hand.busted? && player_hand.five_cards?

        if dealer_wins?
          0
        elsif push?
          2
        else # Player wins
          1
        end
      end

      def dealer_wins?
        player_hand.busted? ||
          (!player_hand.blackjack? && dealer_hand.blackjack?) ||
          (!dealer_hand.busted? && dealer_hand.best_score > player_hand.best_score)
      end

      def winner_translation
        WINNER_TRANSLATIONS[winner]
      end

      def validate
        raise "Dealer hand and Player hand must be present" if dealer_hand.nil? || player_hand.nil?
      end
    end
  end
end
