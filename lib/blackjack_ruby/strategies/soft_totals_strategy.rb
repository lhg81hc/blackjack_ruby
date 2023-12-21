module BlackjackRuby
  module Strategies
    class SoftTotalsStrategy < Base
      DEFAULT_STRATEGIES = {
        'a,9' => { '2' => 'Stay', '3' => 'Stay', '4' => 'Stay', '5' => 'Stay', '6' => 'Stay', '7' => 'Stay', '8' => 'Stay', '9' => 'Stay', '10' => 'Stay', 'a' => 'Stay' },
        'a,8' => { '2' => 'Stay', '3' => 'Stay', '4' => 'Stay', '5' => 'Stay', '6' => 'Double', '7' => 'Stay', '8' => 'Stay', '9' => 'Stay', '10' => 'Stay', 'a' => 'Stay' },
        'a,7' => { '2' => 'Double', '3' => 'Double', '4' => 'Double', '5' => 'Double', '6' => 'Double', '7' => 'Stay', '8' => 'Stay', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
        'a,6' => { '2' => 'Hit', '3' => 'Double', '4' => 'Double', '5' => 'Double', '6' => 'Double', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
        'a,5' => { '2' => 'Hit', '3' => 'Hit', '4' => 'Double', '5' => 'Double', '6' => 'Double', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
        'a,4' => { '2' => 'Hit', '3' => 'Hit', '4' => 'Double', '5' => 'Double', '6' => 'Double', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
        'a,3' => { '2' => 'Hit', '3' => 'Hit', '4' => 'Hit', '5' => 'Double', '6' => 'Double', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
        'a,2' => { '2' => 'Hit', '3' => 'Hit', '4' => 'Hit', '5' => 'Double', '6' => 'Double', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
      }.freeze

      def build_strategies
        DEFAULT_STRATEGIES
      end

      def find_move
        strategies.dig(player_card_ranks, dealer_up_card_rank)
      end

      def find_move!
        found = find_move
        raise 'Unknown move' unless found

        found
      end
    end
  end
end
