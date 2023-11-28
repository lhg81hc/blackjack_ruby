module BlackjackRuby
  module Models
    class PlayerHand < Hand
      # 0 => 'Stay'
      # 1 => 'Hit'
      def options
        if blackjack? || enough? || busted?
          return [0]
        end

        [1]
      end

      def enough?
        scores.any? { |s| s >= 12 && s <= 21 }
      end

      def only_one_option?
        options.count == 1
      end
    end
  end
end
