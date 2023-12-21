module BlackjackRuby
  module Strategies
    class Finder < Base
      # Order of the array is also the order for the look up
      STRATEGIES = [
        PairSplittingStrategy,
        SoftTotalsStrategy,
        HardTotalsStrategy
      ]

      def build_strategies
        nil
      end

      def find_move
        move = nil

        STRATEGIES.each do |strategy|
          move = strategy.new(dealer_up_card, player_hand).find_move
          break unless move.nil?
        end

        raise 'Unknown hand' if move.nil?

        move
      end
    end
  end
end
