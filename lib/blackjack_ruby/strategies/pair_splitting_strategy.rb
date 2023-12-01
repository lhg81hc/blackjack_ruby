module BlackjackRuby
  module Strategies
    class PairSplittingStrategy < Base
      DEFAULT_STRATEGIES = {
        'a,a' => { '2' => 'Y', '3' => 'Y', '4' => 'Y', '5' => 'Y', '6' => 'Y', '7' => 'Y', '8' => 'Y', '9' => 'Y', '10' => 'Y', 'a' => 'Y' },
        '10,10' => { '2' => 'N', '3' => 'N', '4' => 'N', '5' => 'N', '6' => 'N', '7' => 'N', '8' => 'N', '9' => 'N', '10' => 'N', 'a' => 'N' },
        '9,9' => { '2' => 'Y', '3' => 'Y', '4' => 'Y', '5' => 'Y', '6' => 'Y', '7' => 'N', '8' => 'Y', '9' => 'Y', '10' => 'N', 'a' => 'N' },
        '8,8' => { '2' => 'Y', '3' => 'Y', '4' => 'Y', '5' => 'Y', '6' => 'Y', '7' => 'Y', '8' => 'Y', '9' => 'Y', '10' => 'Y', 'a' => 'Y' },
        '7,7' => { '2' => 'Y', '3' => 'Y', '4' => 'Y', '5' => 'Y', '6' => 'Y', '7' => 'Y', '8' => 'N', '9' => 'N', '10' => 'N', 'a' => 'N' },
        '6,6' => { '2' => 'Y', '3' => 'Y', '4' => 'Y', '5' => 'Y', '6' => 'Y', '7' => 'N', '8' => 'N', '9' => 'N', '10' => 'N', 'a' => 'N' },
        '5,5' => { '2' => 'N', '3' => 'N', '4' => 'N', '5' => 'N', '6' => 'N', '7' => 'N', '8' => 'N', '9' => 'N', '10' => 'N', 'a' => 'N' },
        '4,4' => { '2' => 'N', '3' => 'N', '4' => 'N', '5' => 'Y', '6' => 'Y', '7' => 'N', '8' => 'N', '9' => 'N', '10' => 'N', 'a' => 'N' },
        '3,3' => { '2' => 'Y', '3' => 'Y', '4' => 'Y', '5' => 'Y', '6' => 'Y', '7' => 'Y', '8' => 'N', '9' => 'N', '10' => 'N', 'a' => 'N' },
        '2,2' => { '2' => 'Y', '3' => 'Y', '4' => 'Y', '5' => 'Y', '6' => 'Y', '7' => 'Y', '8' => 'N', '9' => 'N', '10' => 'N', 'a' => 'N' }
      }.freeze

      def build_strategies
        DEFAULT_STRATEGIES
      end

      def player_card_to_s
        player_hand.cards.map do |card|
          ['j', 'q', 'k'].include?(card.rank.val) ? '10' : card.rank.val
        end.join(',')
      end

      def split?
        found = strategies[player_card_to_s][dealer_up_card_rank]
        raise 'Unknown move' unless found

        found == 'Y'
      end
    end
  end
end
