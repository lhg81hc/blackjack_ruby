module BlackjackRuby
  module Strategies
    class PairSplittingStrategy < Base
      DEFAULT_STRATEGIES = {
        'a,a' => { '2' => 'Split', '3' => 'Split', '4' => 'Split', '5' => 'Split', '6' => 'Split', '7' => 'Split', '8' => 'Split', '9' => 'Split', '10' => 'Split', 'a' => 'Split' },
        '10,10' => { '2' => nil, '3' => nil, '4' => nil, '5' => nil, '6' => nil, '7' => nil, '8' => nil, '9' => nil, '10' => nil, 'a' => nil },
        '9,9' => { '2' => 'Split', '3' => 'Split', '4' => 'Split', '5' => 'Split', '6' => 'Split', '7' => nil, '8' => 'Split', '9' => 'Split', '10' => nil, 'a' => nil },
        '8,8' => { '2' => 'Split', '3' => 'Split', '4' => 'Split', '5' => 'Split', '6' => 'Split', '7' => 'Split', '8' => 'Split', '9' => 'Split', '10' => 'Split', 'a' => 'Split' },
        '7,7' => { '2' => 'Split', '3' => 'Split', '4' => 'Split', '5' => 'Split', '6' => 'Split', '7' => 'Split', '8' => nil, '9' => nil, '10' => nil, 'a' => nil },
        '6,6' => { '2' => 'Split', '3' => 'Split', '4' => 'Split', '5' => 'Split', '6' => 'Split', '7' => nil, '8' => nil, '9' => nil, '10' => nil, 'a' => nil },
        '5,5' => { '2' => nil, '3' => nil, '4' => nil, '5' => nil, '6' => nil, '7' => nil, '8' => nil, '9' => nil, '10' => nil, 'a' => nil },
        '4,4' => { '2' => nil, '3' => nil, '4' => nil, '5' => 'Split', '6' => 'Split', '7' => nil, '8' => nil, '9' => nil, '10' => nil, 'a' => nil },
        '3,3' => { '2' => 'Split', '3' => 'Split', '4' => 'Split', '5' => 'Split', '6' => 'Split', '7' => 'Split', '8' => nil, '9' => nil, '10' => nil, 'a' => nil },
        '2,2' => { '2' => 'Split', '3' => 'Split', '4' => 'Split', '5' => 'Split', '6' => 'Split', '7' => 'Split', '8' => nil, '9' => nil, '10' => nil, 'a' => nil }
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
