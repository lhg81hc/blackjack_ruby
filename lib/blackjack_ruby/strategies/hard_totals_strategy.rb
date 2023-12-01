module BlackjackRuby
  module Strategies
    class HardTotalsStrategy
      attr_reader :dealer_upcard, :player_hand

      DEFAULT_STRATEGIES = {
        21 => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'S', '8' => 'S', '9' => 'S', '10' => 'S', 'a' => 'S' },
        20 => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'S', '8' => 'S', '9' => 'S', '10' => 'S', 'a' => 'S' },
        19 => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'S', '8' => 'S', '9' => 'S', '10' => 'S', 'a' => 'S' },
        18 => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'S', '8' => 'S', '9' => 'S', '10' => 'S', 'a' => 'S' },
        17 => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'S', '8' => 'S', '9' => 'S', '10' => 'S', 'a' => 'S' },
        16 => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        15 => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        14 => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        13 => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        12 => { '2' => 'H', '3' => 'H', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        11 => { '2' => 'D', '3' => 'D', '4' => 'D', '5' => 'D', '6' => 'D', '7' => 'D', '8' => 'D', '9' => 'D', '10' => 'D', 'a' => 'D' },
        10 => { '2' => 'D', '3' => 'D', '4' => 'D', '5' => 'D', '6' => 'D', '7' => 'D', '8' => 'D', '9' => 'D', '10' => 'H', 'a' => 'H' },
        9 => { '2' => 'H', '3' => 'D', '4' => 'D', '5' => 'D', '6' => 'D', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        8 => { '2' => 'H', '3' => 'H', '4' => 'H', '5' => 'H', '6' => 'H', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        7 => { '2' => 'H', '3' => 'H', '4' => 'H', '5' => 'H', '6' => 'H', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        6 => { '2' => 'H', '3' => 'H', '4' => 'H', '5' => 'H', '6' => 'H', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        5 => { '2' => 'H', '3' => 'H', '4' => 'H', '5' => 'H', '6' => 'H', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        4 => { '2' => 'H', '3' => 'H', '4' => 'H', '5' => 'H', '6' => 'H', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        3 => { '2' => 'H', '3' => 'H', '4' => 'H', '5' => 'H', '6' => 'H', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        2 => { '2' => 'H', '3' => 'H', '4' => 'H', '5' => 'H', '6' => 'H', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        1 => { '2' => 'H', '3' => 'H', '4' => 'H', '5' => 'H', '6' => 'H', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' }
      }.freeze

      def initialize(dealer_upcard, player_hand)
        @dealer_upcard = dealer_upcard
        @player_hand = player_hand

        @strategies = DEFAULT_STRATEGIES
      end

      def hard_total_scores
        @hard_total_scores ||= @strategies.keys
      end

      def player_score
        hard_total = (hard_total_scores & player_hand.scores).first
        raise 'Unknown hard_total' unless hard_total

        hard_total
      end

      def move
        found = @strategies[player_score][dealer_upcard]
        raise 'Unknown move' unless found

        found
      end
    end
  end
end
