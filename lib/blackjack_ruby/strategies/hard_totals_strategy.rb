module BlackjackRuby
  module Strategies
    class HardTotalsStrategy < Base
      DEFAULT_STRATEGIES = {
        16 => { '2' => 'Stay', '3' => 'Stay', '4' => 'Stay', '5' => 'Stay', '6' => 'Stay', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
        15 => { '2' => 'Stay', '3' => 'Stay', '4' => 'Stay', '5' => 'Stay', '6' => 'Stay', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
        14 => { '2' => 'Stay', '3' => 'Stay', '4' => 'Stay', '5' => 'Stay', '6' => 'Stay', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
        13 => { '2' => 'Stay', '3' => 'Stay', '4' => 'Stay', '5' => 'Stay', '6' => 'Stay', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
        12 => { '2' => 'Hit', '3' => 'Hit', '4' => 'Stay', '5' => 'Stay', '6' => 'Stay', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
        11 => { '2' => 'Double', '3' => 'Double', '4' => 'Double', '5' => 'Double', '6' => 'Double', '7' => 'Double', '8' => 'Double', '9' => 'Double', '10' => 'Double', 'a' => 'Double' },
        10 => { '2' => 'Double', '3' => 'Double', '4' => 'Double', '5' => 'Double', '6' => 'Double', '7' => 'Double', '8' => 'Double', '9' => 'Double', '10' => 'Hit', 'a' => 'Hit' },
        9 => { '2' => 'Hit', '3' => 'Double', '4' => 'Double', '5' => 'Double', '6' => 'Double', '7' => 'Hit', '8' => 'Hit', '9' => 'Hit', '10' => 'Hit', 'a' => 'Hit' },
      }.freeze

      def build_strategies
        DEFAULT_STRATEGIES
      end

      def hard_total_scores
        @hard_total_scores ||= strategies.keys
      end

      def player_score
        hard_total = (hard_total_scores & player_hand.scores).first
        raise 'Unknown hard_total' unless hard_total

        hard_total
      end

      def find_move
        best_score = player_hand.best_score

        if best_score >= 17
          return 'Stay'
        end

        if best_score < 9
          return 'Hit'
        end

        strategies.dig(player_score, dealer_up_card_rank)
      end

      def find_move!
        found = find_move
        raise 'Unknown move' unless found

        found
      end

      # def move
      #   found = strategies[player_score][dealer_up_card_rank]
      #   raise 'Unknown move' unless found
      #
      #   found
      # end
    end
  end
end
