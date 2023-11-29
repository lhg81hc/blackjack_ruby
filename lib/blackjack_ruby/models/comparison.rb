module BlackjackRuby
  module Models
    class Comparison
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
        !dealer_hand.busted? &&
          !dealer_hand.blackjack? &&
          dealer_hand.best_score == player_hand.best_score
      end

      def push?
        both_blackjack? || same_best_score?
      end

      alias :tie? :push?

      # 0 => Dealer wins
      # 1 => Player wins
      # 2 => Push
      def winner
        return 2 if push?
        return 0 if dealer_hand.blackjack?
        return 0 if player_hand.busted?
        return 0 if !dealer_hand.busted? && dealer_hand.best_score > player_hand.best_score

        1
      end

      def winner_full
        case winner
        when 0
          'Dealer'
        when 1
          'Player'
        when 2
          'Tie'
        else
          nil
        end
      end

      def validate
        raise "Dealer hand and Player hand must be present" if dealer_hand.nil? || player_hand.nil?
      end
    end
  end
end
