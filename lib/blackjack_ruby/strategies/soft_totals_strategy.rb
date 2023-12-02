module BlackjackRuby
  module Strategies
    class SoftTotalsStrategy < Base
      DEFAULT_STRATEGIES = {
        'a,9' => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'S', '7' => 'S', '8' => 'S', '9' => 'S', '10' => 'S', 'a' => 'S' },
        'a,8' => { '2' => 'S', '3' => 'S', '4' => 'S', '5' => 'S', '6' => 'D', '7' => 'S', '8' => 'S', '9' => 'S', '10' => 'S', 'a' => 'S' },
        'a,7' => { '2' => 'D', '3' => 'D', '4' => 'D', '5' => 'D', '6' => 'D', '7' => 'S', '8' => 'S', '9' => 'H', '10' => 'H', 'a' => 'H' },
        'a,6' => { '2' => 'H', '3' => 'D', '4' => 'D', '5' => 'D', '6' => 'D', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        'a,5' => { '2' => 'H', '3' => 'H', '4' => 'D', '5' => 'D', '6' => 'D', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        'a,4' => { '2' => 'H', '3' => 'H', '4' => 'D', '5' => 'D', '6' => 'D', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        'a,3' => { '2' => 'H', '3' => 'H', '4' => 'H', '5' => 'D', '6' => 'D', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
        'a,2' => { '2' => 'H', '3' => 'H', '4' => 'H', '5' => 'D', '6' => 'D', '7' => 'H', '8' => 'H', '9' => 'H', '10' => 'H', 'a' => 'H' },
      }.freeze

      def build_strategies
        DEFAULT_STRATEGIES
      end

      def move
        found = strategies[player_card_to_s][dealer_up_card_rank]
        raise 'Unknown move' unless found

        found
      end
    end
  end
end
